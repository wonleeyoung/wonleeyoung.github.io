# Run with: bundle exec ruby tests/render_test.rb
# Fixtures live only in a temporary directory, never in the published CV.
require "jekyll"
require "tmpdir"
require "fileutils"
require "yaml"

def assert(condition, message)
  abort "FAIL: #{message}" unless condition
  puts "PASS: #{message}"
end

root = File.expand_path('..', __dir__)
Dir.mktmpdir('cv-render-') do |temp|
  %w[_config.yml _data _layouts _includes index.html manage.md style.css cv.pdf images files].each do |file|
    FileUtils.cp_r(File.join(root, file), temp)
  end
  data_file = File.join(temp, '_data/cv.yml')
  data = YAML.safe_load_file(data_file)
  data['profile']['name'] = 'Name <script>alert(1)</script>'
  data['profile']['photo'] = '/images/test.svg'
  data['profile']['social_links'] = [{ 'label' => 'Blank', 'url' => '' }]
  data['about'] = '**Markdown introduction**'
  data['publications'] = [{
    'title' => 'New <b>paper</b> & data',
    'authors' => ['First Author', data['profile']['name'], 'Last Author'],
    'venue' => 'Test <i>Venue</i>', 'details' => '2026',
    'links' => [{ 'label'=>'PDF', 'url'=>'/cv.pdf' }, { 'label'=>'Code', 'url'=>'https://example.org/?x=1&y=2' }, { 'label'=>'Slides', 'url'=>'files/slides.pdf' }],
    'image' => 'images/test.svg'
  }]
  data['extra_sections'] = [{ 'title'=>'New <b>section</b>', 'body'=>'A **Markdown** section.' }, {'title'=>'', 'body'=>''}]
  File.write(File.join(temp, 'images/test.svg'), '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="50"><rect width="100" height="50" fill="#2f5fd0"/></svg>')
  FileUtils.cp(File.join(root, 'cv.pdf'), File.join(temp, 'files/slides.pdf'))
  build = lambda do
    File.write(data_file, YAML.dump(data))
    config = Jekyll.configuration('source'=>temp, 'destination'=>File.join(temp, '_site'), 'baseurl'=>'/preview', 'quiet'=>true)
    site = Jekyll::Site.new(config)
    Dir.chdir(temp) { site.process }
    File.read(File.join(temp, '_site/index.html'))
  end
  html = build.call
  assert(html.include?('New &lt;b&gt;paper&lt;/b&gt; &amp; data'), 'plain titles are escaped')
  assert(html.include?('<span class="me">Name &lt;script&gt;alert(1)&lt;/script&gt;</span>'), 'matching author is emphasized and escaped')
  authors = html.scan(/First Author.*?Last Author/m).first.to_s.gsub(/\s+/, ' ')
  assert(authors.include?('First Author, <span') && authors.include?('</span>, and Last Author'), 'author order and punctuation are preserved')
  assert(html.include?('<strong>Markdown introduction</strong>') && html.include?('<strong>Markdown</strong>'), 'Markdown renders only in designated body fields')
  %w[/preview/cv.pdf /preview/files/slides.pdf /preview/images/test.svg].each { |url| assert(html.include?(%Q[="#{url}"]), "internal asset resolves with baseurl: #{url}") }
  assert(html.include?('href="https://example.org/?x=1&amp;y=2"'), 'external URL is preserved and escaped')
  assert(html.scan('class="extra-section"').size == 1, 'empty extra sections are hidden')
  assert(!html.include?('>Blank<'), 'empty social URLs are hidden')
  assert(html.include?('class="avatar"') && html.include?('class="pub-image"'), 'uploaded profile and publication images render')
  assert(!html.match?(/\{[{%]/), 'generated homepage contains no Liquid source')
  FileUtils.cp(File.join(temp, 'images/test.svg'), File.join(temp, 'images/test figure.svg'))
  ['/images/test%20figure.svg', '/images/test.svg?v=2#figure', '//example.org/photo.png'].each do |image_url|
    data['profile']['photo'] = image_url
    html = build.call
    assert(html.include?('class="avatar"'), "image URLs with encoding/suffixes and protocol-relative URLs render: #{image_url}")
  end
  data['profile']['photo'] = '/missing.jpg'
  data['profile']['cv'] = ''
  data['profile']['email'] = ''
  data['profile']['links'] = []
  data['publications'][0]['links'] = [{ 'label'=>'Empty', 'url'=>'' }]
  data['publications'][0]['image'] = ''
  data['extra_sections'] = []
  html = build.call
  assert(!html.include?('<img'), 'absent local photo and empty image path leave no images')
  assert(!html.include?('<nav'), 'empty profile and publication links leave no navigation wrappers')
  assert(!html.include?('class="extra-section"'), 'empty section list leaves no section')
  data['profile']['photo'] = ''
  data['publications'][0]['authors'] = ['First', 'Second']
  html = build.call
  assert(html.include?('First and Second.'), 'two-author list has correct punctuation')
end
