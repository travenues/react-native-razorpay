
Pod::Spec.new do |s|
  s.name             = "react-native-razorpay"
  s.version          = "1.0.0"
  s.summary          = "CocoaPod implementation of Razorpay's Payment SDK"
  s.description      = <<-DESC
  Razorpay is a payments platform for e-commerce businesses in India. Razorpay
helps businesses accepts online payments via Credit Card, Debit Card, Net banking
 and Wallets from their end customers. Razorpay provides a secure link between
 merchant website, various issuing institutions, acquiring Banks and the payment
  networks. Razorpay is a developer oriented payment gateway and focuses on
  essentials such as 24x7 support, one line integration code and checkout
  experiences that are very customer friendly.
                       DESC

  s.homepage         = "https://github.com/razorpay/razorpay-pod"
  s.license          = 'MIT'
  s.author           = { "razorpay" => "support@razorpay.com" }
  s.source           = { :git => "https://github.com/razorpay/razorpay-pod.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/razorpay'

  s.platform     = :ios, '10.0'
  s.exclude_files = 'UpdatePod.sh'
s.dependency 'razorpay-pod'

end