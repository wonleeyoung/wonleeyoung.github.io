#!/usr/bin/env ruby
# 추가 gem 없이 실행: ruby scripts/validate_cv.rb [다른 _data/cv.yml 경로]
require "yaml"
require "uri"

class CVValidator
  attr_reader :errors, :warnings

  def initialize(file)
    @file = File.expand_path(file)
    @root = File.dirname(File.dirname(@file))
    @errors, @warnings, @lines = [], [], {}
  end

  def error(path, message)
    @errors << "#{@file}:#{@lines[path] || 1} (#{path}) #{message}"
    nil
  end

  def mapping(value, path, keys)
    return error(path, "항목은 '키: 값' 형식이어야 합니다.") unless value.is_a?(Hash)
    (value.keys - keys).each { |key| error("#{path}.#{key}", "알 수 없는 항목입니다. /manage/의 필드 이름을 확인하세요.") }
    value
  end

  def string(value, path, required: false)
    if required && (!value.is_a?(String) || value.strip.empty?)
      error(path, "필수 문자열입니다. 값을 입력하고 날짜·콜론이 있으면 따옴표로 감싸세요.")
    elsif !value.nil? && !value.is_a?(String)
      error(path, "문자열이어야 합니다. 값을 따옴표로 감싸세요.")
    end
  end

  def list(value, path, required: false)
    return [] if value.nil? && !required
    unless value.is_a?(Array)
      error(path, "목록이어야 합니다. 각 항목 앞에 '- '를 쓰고, 비어 있으면 []로 쓰세요.")
      return []
    end
    error(path, "하나 이상의 항목이 필요합니다.") if required && value.empty?
    value
  end

  def url(value, path, asset: false, optional_image: false)
    string(value, path)
    return unless value.is_a?(String) && !value.strip.empty?
    value = value.strip
    if value.match?(/[\s<>\\]/) || value.match?(/\A(?!https?:|mailto:|tel:)[a-z][a-z0-9+.-]*:/i)
      return error(path, "http(s) URL 또는 루트 기준 경로를 사용하세요. 공백은 %20으로 쓰세요.")
    end
    return if value.match?(/\A(?:https?:\/\/|mailto:|tel:|\/\/|#)/i)
    relative = URI::DEFAULT_PARSER.unescape(value.split(/[?#]/).first.to_s).sub(%r{\A/}, "")
    return error(path, "저장소 루트 기준 경로를 사용하세요. ../ 또는 ./는 사용할 수 없습니다.") if relative.split('/').any? { |part| ['..', '.'].include?(part) }
    return unless asset || File.extname(relative) != ""
    current = @root
    exists = relative.split('/').all? do |part|
      found = File.directory?(current) && Dir.children(current).include?(part)
      current = File.join(current, part)
      found
    end
    unless exists && File.file?(current)
      message = "#{@file}:#{@lines[path] || 1} (#{path}) 파일이 없습니다: #{value}. 업로드 여부와 대소문자를 확인하세요."
      optional_image ? @warnings << "#{message} 사진/그림은 표시하지 않습니다." : @errors << message
    end
  end

  def links(value, path)
    list(value, path).each_with_index do |link, i|
      key = "#{path}[#{i+1}]"
      next unless mapping(link, key, %w[label url])
      string(link['label'], "#{key}.label", required: !link['url'].to_s.strip.empty?)
      url(link['url'], "#{key}.url")
    end
  end

  # AST로 실제 줄 번호와 중복 키를 찾아, 조용히 덮어쓴 YAML 값도 검출합니다.
  def locations(node, path = '')
    @lines[path] = node.start_line + 1
    if node.is_a?(Psych::Nodes::Mapping)
      seen = []
      node.children.each_slice(2) do |key, value|
        child = path.empty? ? key.value : "#{path}.#{key.value}"
        @lines[child] = key.start_line + 1
        error(child, "중복 키입니다. 같은 이름의 키는 하나만 남기세요.") if seen.include?(key.value)
        seen << key.value
        locations(value, child)
      end
    elsif node.is_a?(Psych::Nodes::Sequence)
      node.children.each_with_index { |child, i| locations(child, "#{path}[#{i+1}]") }
    end
  end

  def validate
    source = File.read(@file, encoding: 'UTF-8')
    ast = Psych.parse(source, filename: @file)
    locations(ast.root) if ast && ast.root
    data = YAML.safe_load(source, permitted_classes: [], aliases: false, filename: @file)
    return unless mapping(data, 'cv', %w[profile seo about education interests publications awards teaching extra_sections])
    profile = data['profile']
    if mapping(profile, 'profile', %w[name title affiliation address email photo cv cv_label social_links links])
      %w[name title affiliation address email cv_label].each { |k| string(profile[k], "profile.#{k}", required: k == 'name') }
      url(profile['photo'], 'profile.photo', asset: true, optional_image: true)
      url(profile['cv'], 'profile.cv', asset: true)
      %w[social_links links].each { |k| links(profile[k], "profile.#{k}") }
    end
    if mapping(data['seo'], 'seo', %w[description social_description])
      %w[description social_description].each { |k| string(data['seo'][k], "seo.#{k}") }
    end
    string(data['about'], 'about')
    list(data['interests'], 'interests').each_with_index { |s, i| string(s, "interests[#{i+1}]", required: true) }
    {
      'education' => [%w[date organization degree note location], %w[date organization degree]],
      'awards' => [%w[title details date], %w[title]],
      'teaching' => [%w[title details date], %w[title]],
      'extra_sections' => [%w[title body], %w[title body]]
    }.each do |section, (keys, required)|
      list(data[section], section).each_with_index do |item, i|
        path = "#{section}[#{i+1}]"
        next unless mapping(item, path, keys)
        keys.each { |k| string(item[k], "#{path}.#{k}", required: required.include?(k)) }
      end
    end
    list(data['publications'], 'publications').each_with_index do |paper, i|
      path = "publications[#{i+1}]"
      next unless mapping(paper, path, %w[title authors venue details links image])
      %w[title venue details].each { |k| string(paper[k], "#{path}.#{k}", required: k != 'details') }
      list(paper['authors'], "#{path}.authors", required: true).each_with_index { |a, j| string(a, "#{path}.authors[#{j+1}]", required: true) }
      links(paper['links'], "#{path}.links")
      url(paper['image'], "#{path}.image", asset: true, optional_image: true)
    end
  rescue Psych::SyntaxError => e
    @errors << "#{@file}:#{e.line}:#{e.column} YAML 문법 오류: #{e.problem}. 탭 대신 공백 두 칸, 콜론 뒤 공백, 따옴표 짝을 확인하세요."
  rescue Psych::Exception, Errno::ENOENT => e
    @errors << "#{@file}:1 #{e.message}. 날짜는 따옴표로 감싸고 YAML 별칭은 사용하지 마세요."
  end
end

if $PROGRAM_NAME == __FILE__
  validator = CVValidator.new(ARGV[0] || File.expand_path('../_data/cv.yml', __dir__))
  validator.validate
  validator.warnings.each { |s| warn "주의: #{s}" }
  validator.errors.each { |s| warn "오류: #{s}" }
  abort "CV 검증 실패 (#{validator.errors.length}개). 위 위치를 고친 뒤 다시 실행하세요." unless validator.errors.empty?
  puts "CV 검증 통과. (외부 링크 응답은 별도로 확인하세요.)"
end
