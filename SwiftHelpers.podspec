Pod::Spec.new do |s|
  s.name             = "SwiftHelpers"
  s.version          = "0.2.0"
  s.summary          = "Various Swift helper, extension and convenience stuff."
  s.description      = "A collection of various simple helpers and extensions, mostly Swift-only."

  s.homepage         = "https://github.com/bartekchlebek/SwiftHelpers"
  s.license          = 'MIT'
  s.author           = { "Bartek Chlebek" => "bartek.chlebek@gmail.com" }
  s.source           = { :git => "https://github.com/bartekchlebek/SwiftHelpers.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bartekchlebek'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.requires_arc = true

  s.source_files = 'Source/**/*'

  s.subspec 'Diff' do |cs|
    cs.source_files = [
      'Source/Diff/*',
      'Source/Dictionary/Dictionary+SequenceMap.swift',
      'Source/SequenceType/SequenceType+Find.swift'
    ]
  end

  s.subspec 'Dispatch' do |cs|
    cs.source_files = 'Source/Dispatch/*'
  end

  s.subspec 'Optional' do |cs|
    cs.source_files = 'Source/Optional/*'
  end
end
