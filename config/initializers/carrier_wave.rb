if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['AKIAI2WQMMQCNPEOHL7A'],
      :aws_secret_access_key => ENV['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']
    }
    config.fog_directory     =  ENV['confused-bucket']
  end
end
