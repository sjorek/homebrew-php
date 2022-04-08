
require 'json'
require 'rake'

Rake.application.options.trace_rules = true

FORMULAE = Rake::FileList.new("Formula/*.rb") do |formula|
  formula.exclude(/^dist\//)
  formula.exclude do |f|
    `git ls-files #{f}`.empty?
  end
end

BREW_TAP_INSTALLED = 'dist/brew-tap-installed.json'
BREW_TAP_OUTDATED  = 'dist/brew-tap-outdated.json'
COMPOSER_VERSIONS  = 'dist/composer-versions.json'

task :default => :all
task :all => [:clean,:build]
task :installed => :all # @see ARGV usage in generate_build_tasks below
task :outdated => :all # @see ARGV usage in generate_build_tasks below
task :build => FORMULAE

directory "dist"

file 'dist/composer-setup.sha384' => :dist do |t|
  sh "curl -s -o #{t.name} https://composer.github.io/installer.sig"
end

file 'dist/composer-setup.sha256' => :dist do |t|
  sh "php -r 'echo hash_file(\"sha256\", \"https://getcomposer.org/installer\");' >#{t.name}"
end

def generate_build_tasks composer_build_targets

  installed_versions = if File.file?(BREW_TAP_INSTALLED) then JSON.parse(File.read(BREW_TAP_INSTALLED)) else [] end
  outdated_versions  = if File.file?(BREW_TAP_OUTDATED) then JSON.parse(File.read(BREW_TAP_OUTDATED)) else [] end
  composer_versions  = if File.file?(COMPOSER_VERSIONS) then JSON.parse(File.read(COMPOSER_VERSIONS)) else [] end

  task :clean do
    rm_rf "dist"
    installed_versions = []
    outdated_versions  = []
    composer_versions  = []
  end

  file BREW_TAP_INSTALLED => :dist do |t|
    #File.write(t.name, '[]')
    sh "brew info --json $( brew list --full-name --formula -1 | grep -E '^sjorek/php/' ) >#{t.name}"
    installed_versions = JSON.parse(File.read(t.name))
  end

  file BREW_TAP_OUTDATED => :dist do |t|
    #File.write(t.name, '[{"formula":"composer2-php72","version":{"current":"2.0.14","latest":"2.1.1","outdated":true,"newer_than_upstream":false}},{"formula":"composer2-php73","version":{"current":"2.0.14","latest":"2.1.1","outdated":true,"newer_than_upstream":false}},{"formula":"composer2-php74","version":{"current":"2.0.14","latest":"2.1.1","outdated":true,"newer_than_upstream":false}},{"formula":"composer2-php80","version":{"current":"2.0.14","latest":"2.1.1","outdated":true,"newer_than_upstream":false}},{"formula":"composer@2","version":{"current":"2.0.14","latest":"2.1.1","outdated":true,"newer_than_upstream":false}}]')
    #File.write(t.name, '[]')
    sh "brew livecheck --quiet --newer-only --json --tap sjorek/php >#{t.name}"
    outdated_versions = JSON.parse(File.read(t.name))
  end

  file COMPOSER_VERSIONS => :dist do |t|
    sh "curl -s -o #{t.name} https://getcomposer.org/versions"
    composer_versions = JSON.parse(File.read(t.name))
  end

  composer_build_targets.map { |composer_build_target|

    composer_version = composer_build_target['version']

    file "dist/composer#{composer_version}.sha256" => :dist do |t|
      sh "curl -s -o #{t.name} https://getcomposer.org/download/latest-#{composer_version}.x/composer.phar.sha256"
    end

    file "dist/composer#{composer_version}.json" => [COMPOSER_VERSIONS, "dist/composer#{composer_version}.sha256"] do |t|
      composer = composer_versions[composer_version][0];
      composer['sha256'] = File.read(t.sources[1])
      File.write(t.name, JSON.generate(composer))
      composer_versions[composer_version] = composer
    end

    composer_build_target['targets'].map { |build_target|

      build_target['versions'].map { |php_build|

        php_version = php_build['version']
        php_formula = php_build['formula']

        target  = build_target['source'].pathmap('%{^Source/,Formula/}X.rb')
            .gsub(/X/,  composer_version)
            .gsub(/YZ/, php_version.split('.').slice(0,2).join())

        sources = [
            build_target['source'],
            "dist/composer#{composer_version}.json",
            'dist/composer-setup.sha256',
            'dist/composer-setup.sha384'
        ]
        sources.push(BREW_TAP_INSTALLED) if ARGV.include? 'installed'
        sources.push(BREW_TAP_OUTDATED) if ARGV.include? 'outdated'

        file target => sources do |t|

          name          = t.name.pathmap('%n')
          formula       = File.read(t.name)
          setup_sha256  = File.read(t.sources[2])
          setup_sha384  = File.read(t.sources[3])
          composer      = composer_versions[composer_version]
          installed     = installed_versions.any? { |each| each["name"] == name }
          outdated      = outdated_versions.any? { |each| each["formula"] == name }
          rebuild       = false == uptodate?(t.name, ['Rakefile', t.source])
          revision      = if outdated then 0 else formula.match(/^ +revision +(\d+)$/).captures[0].to_i end

          if outdated || rebuild then

            source = File.read(t.source)
              .gsub(/COMPOSER_VERSION_MAJOR/,   composer['version'].split('.')[0])
              .gsub(/COMPOSER_VERSION_MINOR/,   composer['version'].split('.')[1])
              .gsub(/COMPOSER_VERSION_PATCH/,   composer['version'].split('.')[2])
              .gsub(/COMPOSER_PHAR_SHA256/,     composer['sha256'])
              .gsub(/COMPOSER_SETUP_SHA256/,    setup_sha256)
              .gsub(/COMPOSER_SETUP_SHA384/,    setup_sha384)
              .gsub(/PHP_FORMULA/,              php_formula)
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

            readme = File.read('README.md').gsub(/^( +#{name} +)[0-9._]+$/, "\\1#{composer['version']}_#{revision}")
            File.write('README.md', readme)
            sh "git add README.md"
          end

          puts ""
          puts "source     : #{t.source}"
          puts "target     : #{t.name}"
          puts "formula    : #{name}"
          puts "version    : #{composer['version']}"
          puts "revision   : #{revision}"
          puts "sha256     : #{composer['sha256']}"
          puts "installed? : #{installed}"
          puts "outdated?  : #{outdated}"
          puts "rebuild?   : #{rebuild}"
          puts ""

        end

      }
    }
  }

end

generate_build_tasks [
  {
    'version' => '1',
    'targets' => [
      {
        'source'   => 'Source/composer@X.rb',
        'versions' => [
          {
            'formula' => 'php',
            'version' => '0.0.0'
          },
          {
            'formula' => 'php',
            'version' => '0.0.0'
          }
        ]
      },
      {
        'source' => 'Source/composerX-phpYZ.rb',
        'versions' => [
          {
            'formula' => 'shivammathur/php/php',
            'version' => '5.6.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '7.0.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '7.1.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '7.2.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '7.3.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '7.4.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.0.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.1.0'
          }
        ]
      }
    ]
  },
  {
    'version' => '2',
    'targets' => [
      {
        'source'   => 'Source/composer@X.rb',
        'versions' => [
          {
            'formula' => 'php',
            'version' => '0.0.0'
          },
          {
            'formula' => 'php',
            'version' => '0.0.0'
          }
        ]
      },
      {
        'source' => 'Source/composerX-phpYZ.rb',
        'versions' => [
          # {
          #    'formula' => 'shivammathur/php/php',
          #   'version' => '5.6.0'
          # },
          # {
          #   'formula' => 'shivammathur/php/php',
          #   'version' => '7.0.0'
          # },
          # {
          #   'formula' => 'shivammathur/php/php',
          #   'version' => '7.1.0'
          # },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '7.2.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '7.3.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '7.4.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.0.0'
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.1.0'
          }
        ]
      }
    ]
  }
]
