
require 'json'
require 'rake'

Rake.application.options.trace_rules = true

FORMULAE = Rake::FileList.new("Formula/*.rb") do |formula|
  formula.exclude(/^dist\//)
  formula.exclude do |f|
    `git ls-files #{f}`.empty?
  end
end

OUTDATED = 'dist/composer-outdated.json'
VERSIONS = 'dist/composer-versions.json'

task :default => :all
task :all => [:clean,:build]
task :outdated => :all # @see ARGV usage in generate_composer_build_tasks below
task :build => FORMULAE

directory "dist"

file 'dist/composer-setup.sha384sum' => :dist do |t|
    sh "curl -s -o #{t.name} https://composer.github.io/installer.sha384sum"
end

def generate_composer_build_tasks composer_versions, build_targets

  all_versions = if File.file?(VERSIONS) then JSON.parse(File.read(VERSIONS)) else [] end
  outdated_versions = if File.file?(OUTDATED) then JSON.parse(File.read(OUTDATED)) else [] end

  task :clean do
    rm_rf "dist"
    outdated_versions = []
    all_versions = []
  end

  file VERSIONS => :dist do |t|
    sh "curl -s -o #{t.name} https://getcomposer.org/versions"
    all_versions = JSON.parse(File.read(t.name))
  end

  file OUTDATED => :dist do |t|
    #File.write(t.name, '[{"formula":"composer2-php72","version":{"current":"2.0.14","latest":"2.1.1","outdated":true,"newer_than_upstream":false}},{"formula":"composer2-php73","version":{"current":"2.0.14","latest":"2.1.1","outdated":true,"newer_than_upstream":false}},{"formula":"composer2-php74","version":{"current":"2.0.14","latest":"2.1.1","outdated":true,"newer_than_upstream":false}},{"formula":"composer2-php80","version":{"current":"2.0.14","latest":"2.1.1","outdated":true,"newer_than_upstream":false}},{"formula":"composer@2","version":{"current":"2.0.14","latest":"2.1.1","outdated":true,"newer_than_upstream":false}}]')
    #File.write(t.name, '[]')
    sh "brew livecheck --quiet --newer-only --json --tap sjorek/php >#{t.name}"
    outdated_versions = JSON.parse(File.read(t.name))
  end

  composer_versions.map { |composer_version|

    file "dist/composer#{composer_version}.sha256sum" => :dist do |t|
      sh "curl -s -o #{t.name} https://getcomposer.org/download/latest-#{composer_version}.x/composer.phar.sha256"
    end

    file "dist/composer#{composer_version}.json" => [VERSIONS, "dist/composer#{composer_version}.sha256sum"] do |t|
      info = all_versions[composer_version][0];
      info['sha256sum'] = File.read(t.sources[1])
      File.write(t.name, JSON.generate(info))
      all_versions[composer_version] = info
    end

    build_targets.map { |build_target|

      build_target['versions'].map { |php_version|

        target  = build_target['source'].pathmap('%{^Source/,Formula/}X.rb')
            .gsub(/X/,  composer_version)
            .gsub(/YZ/, php_version.split('.').slice(0,2).join())

        sources = [
            build_target['source'],
            "dist/composer#{composer_version}.json",
            'dist/composer-setup.sha384sum'
        ]
        sources.push(OUTDATED) if ARGV.include? 'outdated'

        file target => sources do |t|

          name      = t.name.pathmap('%n')
          formula   = File.read(t.name)
          setup     = File.read(t.sources[2])
          info      = all_versions[composer_version]
          outdated  = outdated_versions.any? { |each| each["formula"] == name }
          rebuild   = false == uptodate?(t.name, ['Rakefile', t.source])
          revision  = if outdated then 0 else formula.match(/^ +revision +(\d+)$/).captures[0].to_i end

          if outdated || rebuild then

            source = File.read(t.source)
              .gsub(/COMPOSER_VERSION_MAJOR/,   info['version'].split('.')[0])
              .gsub(/COMPOSER_VERSION_MINOR/,   info['version'].split('.')[1])
              .gsub(/COMPOSER_VERSION_PATCH/,   info['version'].split('.')[2])
              .gsub(/COMPOSER_PHAR_SHA256SUM/,  info['sha256sum'])
              .gsub(/COMPOSER_SETUP_SHA384SUM/, setup)
              .gsub(/PHP_VERSION_MAJOR/,        php_version.split('.')[0])
              .gsub(/PHP_VERSION_MINOR/,        php_version.split('.')[1])
              .gsub(/PHP_VERSION_PATCH/,        php_version.split('.')[2])
              .gsub(/FORMULA_REVISION/,         "#{revision}")

            if source != formula then
              if false == outdated then
                revision += 1
                source = source.gsub(/^( +revision +)\d+$/, "\\1#{revision}")
              end
              File.write(t.name, source)
              sh "git add #{t.name}"
            end

            readme = File.read('README.md').gsub(/^( +#{name} +)[0-9._]+$/, "\\1#{info['version']}_#{revision}")
            File.write('README.md', readme)
            sh "git add README.md"
          end

          puts ""
          puts "source    : #{t.source}"
          puts "target    : #{t.name}"
          puts "formula   : #{name}"
          puts "version   : #{info['version']}"
          puts "revision  : #{revision}"
          puts "sha256sum : #{info['sha256sum']}"
          puts "outdated? : #{outdated}"
          puts "rebuild?  : #{rebuild}"
          puts ""

        end

      }
    }
  }

end

generate_composer_build_tasks ['1', '2'], [
    {
        'source'   => 'Source/composer@X.rb',
        'versions' => ['0.0.0']
    },
    {
        'source' => 'Source/composerX-phpYZ.rb',
        'versions' => ['7.2.0', '7.3.0', '7.4.0', '8.0.0']
    }
]
