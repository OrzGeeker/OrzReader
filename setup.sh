# !/usr/bin/env bash
# -*- coding: utf-8 -*-
# ref: https://docs.fastlane.tools/getting-started/ios/setup/

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

cat > Gemfile <<EOF
source "https://rubygems.org"
gem "fastlane"
EOF

bundle update

# Run [sudo] bundle update and add both the ./Gemfile and the ./Gemfile.lock to version control
# Every time you run fastlane, use bundle exec fastlane [lane]
# On your CI, add [sudo] bundle install as your first build step
# To update fastlane, just run [sudo] bundle update fastlane

# Setting up fastlane
# Navigate your terminal to your project's directory and run
# fastlane init
# To have your Fastfile configuration written in Swift (Beta)
bundle exec fastlane init swift
# The most interesting file is fastlane/Fastfile, 
# which contains all the information that is needed to 
# distribute your app.