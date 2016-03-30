Pod::Spec.new do |s|
  s.name             = "SwiftHelpers"
  s.version          = "0.1.0"
  s.summary          = "Various Swift helper, extension and convenience stuff."
  s.description      = "A collection of various simple helpers and extensions, mostly Swift-only."

  s.homepage         = "https://github.com/bartekchlebek/SwiftHelpers"
  s.license          = 'MIT'
  s.author           = { "Bartek Chlebek" => "bartek.chlebek@gmail.com" }
  s.source           = { :git => "https://github.com/bartekchlebek/SwiftHelpers.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/bartekchlebek'

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.subspec 'Diff' do |cs|
    cs.source_files = [
      'Pod/Classes/Diff/*',
      'Pod/Classes/Dictionary/Dictionary+SequenceMap.swift',
      'Pod/Classes/SequenceType/SequenceType+Find.swift'
    ]
  end
end
