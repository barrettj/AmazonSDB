Pod::Spec.new do |s|
  s.name         = "AmazonSDB"
  s.version      = "0.0.1"
  s.summary      = "A fork of brcosm's AmazonSDB (an iOS interface to Amazon's SimpleDB web service).  Changes: Uses Blocks instead of a delegate, has better error handling, support for multi-value attributes, and more."
  # s.description  = <<-DESC
  #                   An optional longer description of AmazonSDB
  #
  #                   * Markdonw format.
  #                   * Don't worry about the indent, we strip it!
  #                  DESC
  s.homepage     = "https://github.com/barrettj/AmazonSDB"

  s.license      = 'Unknown'
  s.authors      = { "Barrett Jacobsen" => "admin@barrettj.com", "Brandon Smith" => "brcosm@gmail.com" }
  s.source       = { :git => "https://github.com/barrettj/AmazonSDB.git",  }
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.source_files = 'SDB/SDB'
  s.requires_arc = true
end
