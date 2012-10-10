# We need XQuartz & apple-gcc42 to install Ruby 1.8.7 & REE
include_recipe "xquartz"
include_recipe "homebrew"
homebrew_tap "homebrew/dupes"
package "apple-gcc42"

case node["ruby_manager"]["manager"]
when "rbenv"
  package "rbenv"
  package "ruby-build"

  cookbook_file "#{ENV['HOME']}/.bash_profile" do
    source "rbenv_bash_profile"
    not_if { ::File.exists?("#{ENV['HOME']}/.bash_profile") }
  end

  node["ruby_manager"]["rubies"].each do |ruby_version|
    execute "install ruby #{ruby_version}" do
      command "env CPPFLAGS=-I/opt/X11/include rbenv install #{ruby_version}"
      not_if "rbenv versions | grep -q #{ruby_version}"
    end
  end

  #node{"ruby_manager"]["gems"].each do |ruby_version, gems|
  #  gems.each do |gem_name, gem_version|
#
#    end
#  end
when "rvm"
end
