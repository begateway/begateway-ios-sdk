#
# Be sure to run `pod lib lint begateway.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name                    = 'begateway'
    s.version                 = '3.0.3'
    s.summary                 = 'Little framework to easy implement https://begateway.com/ in yout application'
    s.swift_version           = '5.0'
    s.ios.deployment_target   = '11.0'
    s.dependency              'SwiftyRSA'
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
    s.author           = { 'eComCharge LLC' => 'techsupport@ecomcharge.com' }
    s.source           = { :git => 'https://github.com/begateway/begateway-ios-sdk.git', :tag => s.version }

    
    s.source_files     = 'begateway/**/**/*.{swift,h,m}'
    s.requires_arc     = true
    s.frameworks       = 'UIKit'
    s.frameworks       = 'Security'
    
    s.resources        = ['begateway/Classes/**/*.*',
                        'begateway/Localization/*.lproj/*.strings',
                        'begateway/**/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}']

end
