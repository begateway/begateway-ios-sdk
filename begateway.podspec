#
# Be sure to run `pod lib lint begateway.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name                    = 'begateway'
    s.version                 = '1.03'
    s.summary                 = 'Little framework to easy implement https://begateway.com/ in yout application'
    s.swift_version           = '5.0'
    s.ios.deployment_target   = '10.0'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    Whether you launch a new payment service provider or plan to replace the current processing system software with something technologically advanced and progressive to offer your customers a new level of service, we are ready to help and provide you our beGateway- payment gateway white label solution.
    DESC
    
    s.homepage         = 'https://begateway.com/'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Fedar Trukhan' => 'f.trukhan@gmail.com' }
    s.source           = { :git => 'https://github.com/begateway/begateway-ios-sdk.git', :tag => s.version }
    
    s.ios.deployment_target = '10.0'
    
    s.source_files = 'begateway/Classes/**/*.{swift,h,m}'
    s.requires_arc = true
    s.resource_bundle = { "begatewaybundle" => ["begateway/Localization/*.lproj/*.strings"] }
    s.frameworks = 'UIKit'
    s.frameworks = 'Security'
    s.resources = '{begateway/Assets/**/*.*}'
    
end
