require "rake"

load File.join(
  Gem::Specification.find_by_name("middleman-gh-pages").full_gem_path,
  "lib",
  "middleman-gh-pages",
  "tasks",
  "gh-pages.rake"
)

# middleman-gh-pages 0.4.1 calls Rake's legacy `mv` wrapper, which is not
# compatible with modern Ruby's keyword arguments. Keep the gem's behavior
# while calling FileUtils directly and always restoring the Pages checkout.
def backup_and_restore(dir, file)
  return yield unless File.exist?(File.join(dir, file))

  Dir.mktmpdir do |tmpdir|
    source = File.join(dir, file)
    backup = File.join(tmpdir, file)
    FileUtils.mv(source, backup)
    begin
      yield
    ensure
      FileUtils.mv(backup, source) if File.exist?(backup)
    end
  end
end

# Ignore errors about dirty `middleman-gh-pages` builds
ENV["ALLOW_DIRTY"] = "true"

def publish_remote_name
  ENV.fetch("REMOTE_NAME", "origin")
end

def publish_branch_name
  ENV.fetch("BRANCH_NAME", "gh-pages")
end

Rake::Task["sync_build_dir"].clear
task :sync_build_dir => :prepare_build_dir do
  Dir.chdir(BUILD_DIR) do
    abort "git fetch failed" unless system("git", "fetch", publish_remote_name, publish_branch_name)

    remote_branch = "#{publish_remote_name}/#{publish_branch_name}"
    local_branch = `git rev-parse --abbrev-ref HEAD`.chomp
    branch_exists = system("git", "show-ref", "--verify", "--quiet", "refs/heads/#{publish_branch_name}")

    if branch_exists
      unless local_branch == publish_branch_name
        abort "git checkout failed" unless system("git", "checkout", publish_branch_name)
      end
    else
      abort "git checkout failed" unless system("git", "checkout", "-B", publish_branch_name, remote_branch)
    end

    abort "git reset failed" unless system("git", "reset", "--hard", remote_branch)
  end
end

Rake::Task["build"].clear
desc "Compile all files into the build directory"
task :build do
  backup_and_restore(BUILD_DIR, ".git") do
    Dir.chdir(PROJECT_ROOT) do
      built = Bundler.with_unbundled_env do
        system("bundle", "exec", "middleman", "build", "--clean")
      end
      abort "Middleman build failed" unless built
    end
  end
end

Rake::Task["publish"].clear
desc "Build and publish to Github Pages"
task :publish => [:prevent_dirty_builds, :sync_build_dir, :build] do
  suffix = ENV["COMMIT_MESSAGE_SUFFIX"]
  head = Dir.chdir(PROJECT_ROOT) { `git log --pretty="%h" -n1`.chomp }
  message = ["Site updated to #{head}", suffix].compact.join("\n\n")

  Dir.chdir(BUILD_DIR) do
    abort "git add failed" unless system("git", "add", "--all")
    unless `git status --porcelain`.chomp.empty?
      abort "git commit failed" unless system("git", "commit", "-m", message)
    end
    abort "git push failed" unless system("git", "push", publish_remote_name, publish_branch_name)
  end
end

namespace :posts do
  desc "Create a new blog post"
  task :new, :title do |t, args|
    abort "Error: You must pass in a name for the post." unless args[:title]

    post_name = post_name(args[:title])
    sh "touch ./source/posts/#{post_name}; subl ./source/posts/#{post_name}"
  end
end

def post_name(title)
  date = Date.today.strftime('%Y-%m-%d')
  file_type = ".html.markdown"
  title = title.downcase.split(" ").join("-")

  "#{date}-" + "#{title}" + "#{file_type}"
end
