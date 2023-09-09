# frozen_string_literal: true

require 'net/http'
require 'json'
require 'rake'
require 'digest'

Rake.application.options.trace_rules = true

BUILD_TARGETS = [
  {
    'version' => '1',
    'version_short' => '1',
    'versions_url' => 'https://getcomposer.org/versions',
    'sha256_url' => 'https://getcomposer.org/download/latest-1.x/composer.phar.sha256',
    'archive' => true,
    'targets' => [
      {
        'source' => 'Source/composer@XY.rb',
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
        'source' => 'Source/composer-phpYZ@XY.rb',
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      },
      {
        'source' => 'Source/composerXY-phpYZ.rb',
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      }
    ]
  },
  {
    'version' => '2.2',
    'version_short' => '2.2',
    'versions_url' => 'https://getcomposer.org/versions',
    'sha256_url' => 'https://getcomposer.org/download/latest-2.2.x/composer.phar.sha256',
    'archive' => true,
    'targets' => [
      {
        'source' => 'Source/composer@XY.rb',
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
        'source' => 'Source/composer-phpYZ@XY.rb',
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      },
      {
        'source' => 'Source/composerXY-phpYZ.rb',
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      }
    ]
  },
  {
    'version' => '2.3',
    'version_short' => '2',
    'versions_url' => 'archive/composer23.json',
    'sha256_url' => 'archive/composer23.sha256',
    'archive' => false,
    'targets' => [
      {
        'source' => 'Source/composer@XY.rb',
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
        'source' => 'Source/composer-phpYZ@XY.rb',
        'versions' => [
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      },
      {
        'source' => 'Source/composerXY-phpYZ.rb',
        'versions' => [
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      }
    ]
  },
  {
    'version' => '2.4',
    'version_short' => '2',
    'versions_url' => 'archive/composer24.json',
    'sha256_url' => 'archive/composer24.sha256',
    'archive' => false,
    'targets' => [
      {
        'source' => 'Source/composer@XY.rb',
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
        'source' => 'Source/composer-phpYZ@XY.rb',
        'versions' => [
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      },
      {
        'source' => 'Source/composerXY-phpYZ.rb',
        'versions' => [
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      }
    ]
  },
  {
    'version' => '2.5',
    'version_short' => '2',
    'versions_url' => 'https://getcomposer.org/versions',
    'sha256_url' => 'https://getcomposer.org/download/latest-2.x/composer.phar.sha256',
    'archive' => false,
    'targets' => [
      {
        'source' => 'Source/composer@XY.rb',
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
        'source' => 'Source/composer-phpYZ@XY.rb',
        'versions' => [
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      },
      {
        'source' => 'Source/composerXY-phpYZ.rb',
        'versions' => [
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      }
    ]
  },
  {
    'version' => '2.6',
    'version_short' => '2',
    'versions_url' => 'https://getcomposer.org/versions',
    'sha256_url' => 'https://getcomposer.org/download/latest-2.x/composer.phar.sha256',
    'archive' => true,
    'targets' => [
      {
        'source' => 'Source/composer@XY.rb',
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
        'source' => 'Source/composer-phpYZ@XY.rb',
        'versions' => [
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      },
      {
        'source' => 'Source/composerXY-phpYZ.rb',
        'versions' => [
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
          },
          {
            'formula' => 'shivammathur/php/php',
            'version' => '8.2.0'
          }
        ]
      }
    ]
  }
].freeze

FORMULAE = []

BUILD_TARGETS.map { |composer_build_target|
  composer_build_target['targets'].map { |build_target|
    composer_version = composer_build_target['version']
    build_target['versions'].map { |php_build|
      php_version = php_build['version']
      target = build_target['source'].pathmap('%{^Source/,Formula/}X.rb')
                                     .gsub(/XY/, composer_version.split('.').slice(0, 2).join)
                                     .gsub(/YZ/, php_version.split('.').slice(0, 2).join)
      php_build['target'] = target

      FORMULAE.push target
    }
  }
}

FORMULAE.freeze

BREW_TAP_INSTALLED = 'dist/brew-tap-installed.json'
BREW_TAP_OUTDATED  = 'dist/brew-tap-outdated.json'

task :default => :all
task :all => [:clean,:build]
task :installed => :all # @see ARGV usage in generate_build_tasks below
task :outdated => :all # @see ARGV usage in generate_build_tasks below
task :build => FORMULAE

directory 'dist'

file 'dist/composer-setup.sha384' => :dist do |t|
  sh "curl -s -o #{t.name} https://composer.github.io/installer.sig"
end

file 'dist/composer-setup.sha256' => :dist do |t|
  # sh "php -r 'echo hash_file(\"sha256\", \"https://getcomposer.org/installer\");' >#{t.name}"
  File.write(t.name, Digest::SHA256.hexdigest(Net::HTTP.get(URI("https://getcomposer.org/installer"))))
end

def generate_build_tasks(composer_build_targets)

  installed_versions = if File.file?(BREW_TAP_INSTALLED)
                         JSON.parse(File.read(BREW_TAP_INSTALLED))
                       else
                         []
                       end

  outdated_versions  = if File.file?(BREW_TAP_OUTDATED)
                         JSON.parse(File.read(BREW_TAP_OUTDATED))
                       else
                         []
                       end

  task :clean do
    rm_rf 'dist'
    installed_versions = []
    outdated_versions  = []
  end

  file BREW_TAP_INSTALLED => :dist do |t|
    # File.write(t.name, '[]')
    sh "brew info --json $( brew list --full-name --formula -1 | grep -E '^sjorek/php/' ) >#{t.name}"
    installed_versions = JSON.parse(File.read(t.name))
  end

  file BREW_TAP_OUTDATED => :dist do |t|
    # File.write(t.name, '[]')
    sh "brew livecheck --quiet --newer-only --json --tap sjorek/php >#{t.name}"
    outdated_versions = JSON.parse(File.read(t.name))
  end

  composer_build_targets.map { |composer_build_target|

    composer_version = composer_build_target['version']
    composer_version_short = composer_build_target['version_short']
    composer_version_formula = composer_version.split('.').slice(0, 2).join
    composer_archive = composer_build_target['archive']

    composer_versions_url = composer_build_target['versions_url']
    composer_sha256_url = composer_build_target['sha256_url']

    if composer_sha256_url.start_with?('archive/')
      file "dist/composer#{composer_version_formula}.sha256" => [composer_sha256_url] do |t|
        FileUtils.copy_file(t.sources[0], t.name)
      end
    else
      File.delete("archive/composer#{composer_version_formula}.sha256") if File.exist?("archive/composer#{composer_version_formula}.sha256")
      file "dist/composer#{composer_version_formula}.sha256" => :dist do |t|
        File.write(t.name, Net::HTTP.get(URI(composer_sha256_url)))
      end
    end

    if composer_versions_url.start_with?('archive/')
      file "dist/composer#{composer_version_formula}.json" => [composer_versions_url] do |t|
        FileUtils.copy_file(t.sources[0], t.name)
      end
    else
      File.delete("archive/composer#{composer_version_formula}.json") if File.exist?("archive/composer#{composer_version_formula}.json")
      file "dist/composer#{composer_version_formula}.json" => ["dist/composer#{composer_version_formula}.sha256"] do |t|
        composer = JSON.parse(Net::HTTP.get(URI(composer_versions_url)))[composer_version_short][0]
        composer['sha256'] = File.read(t.sources[0])
        File.write(t.name, JSON.generate(composer))
      end
    end

    if composer_archive
      file "archive/composer#{composer_version_formula}.sha256" => ["dist/composer#{composer_version_formula}.sha256"] do |t|
        FileUtils.copy_file(t.sources[0], t.name)
      end
      file "archive/composer#{composer_version_formula}.json" => ["dist/composer#{composer_version_formula}.json"] do |t|
        FileUtils.copy_file(t.sources[0], t.name)
      end
    end

    composer_build_target['targets'].map { |build_target|

      build_target['versions'].map { |php_build|

        php_version = php_build['version']
        php_formula = php_build['formula']
        target      = php_build['target']

        sources = [
          build_target['source'],
          "dist/composer#{composer_version_formula}.json",
          'dist/composer-setup.sha256',
          'dist/composer-setup.sha384'
        ]
        sources.push(BREW_TAP_INSTALLED) if ARGV.include? 'installed'
        sources.push(BREW_TAP_OUTDATED) if ARGV.include? 'outdated'
        sources.push("archive/composer#{composer_version_formula}.sha256") if composer_archive
        sources.push("archive/composer#{composer_version_formula}.json") if composer_archive

        file target => sources do |t|

          name          = t.name.pathmap('%n')
          formula       = File.file?(t.name) ? File.read(t.name) : ''
          composer      = JSON.parse(File.read(t.sources[1]))
          setup_sha256  = File.read(t.sources[2])
          setup_sha384  = File.read(t.sources[3])
          installed     = installed_versions.any? { |each| each['name'] == name }
          outdated      = !File.file?(t.name) || outdated_versions.any? { |each| each['formula'] == name }
          rebuild       = File.file?(t.name) || uptodate?(t.name, ['Rakefile', t.source]) == false
          revision      = outdated ? 0 : formula.match(/^ +revision +(\d+)$/).captures[0].to_i

          has_install  = formula.match(/fail "invalid checksum for composer-installer" unless "([^"]+)" == composer_setup_sha384/)

          if has_install
            setup_sha384_actual = has_install.captures[0].to_s
            outdated = true unless setup_sha384 == setup_sha384_actual
          end

          if outdated || rebuild

            source = File.read(t.source)
                         .gsub(/COMPOSER_VERSION_MAJOR/,   composer['version'].split('.')[0])
                         .gsub(/COMPOSER_VERSION_MINOR/,   composer['version'].split('.')[1])
                         .gsub(/COMPOSER_VERSION_PATCH/,   composer['version'].split('.')[2])
                         .gsub(/COMPOSER_VERSION_SHORT/,   composer_version_short)
                         .gsub(/COMPOSER_VERSION_FORMULA/, composer_version_formula)
                         .gsub(/COMPOSER_PHAR_SHA256/,     composer['sha256'])
                         .gsub(/COMPOSER_SETUP_SHA256/,    setup_sha256)
                         .gsub(/COMPOSER_SETUP_SHA384/,    setup_sha384)
                         .gsub(/PHP_FORMULA/,              php_formula)
                         .gsub(/PHP_VERSION_MAJOR/,        php_version.split('.')[0])
                         .gsub(/PHP_VERSION_MINOR/,        php_version.split('.')[1])
                         .gsub(/PHP_VERSION_PATCH/,        php_version.split('.')[2])
                         .gsub(/FORMULA_REVISION/,         revision.to_s)

            if source != formula
              if outdated == false
                revision += 1
                source = source.gsub(/^( +revision +)\d+$/, "\\1#{revision}")
              end
              File.write(t.name, source)
              sh "git add #{t.name}"
            end

            readme = File.read('README.md').gsub(/^( +#{name} +)[0-9._]+$/, "\\1#{composer['version']}_#{revision}")
            File.write('README.md', readme)
            sh 'git add README.md'
          end

          puts ''
          puts "source     : #{t.source}"
          puts "target     : #{t.name}"
          puts "formula    : #{name}"
          puts "version    : #{composer['version']}"
          puts "revision   : #{revision}"
          puts "sha256     : #{composer['sha256']}"
          puts "installed? : #{installed}"
          puts "outdated?  : #{outdated}"
          puts "rebuild?   : #{rebuild}"
          puts ''
        end
      }
    }
  }
end

generate_build_tasks BUILD_TARGETS
