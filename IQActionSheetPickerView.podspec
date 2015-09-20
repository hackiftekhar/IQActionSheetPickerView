Pod::Spec.new do |s|
	s.name         = "IQActionSheetPickerView"
	s.version      = "1.0.2"
	s.summary      = "ActionSheet with UIPickerView"
	s.homepage     = "http://github.com/hackiftekhar/IQActionSheetPickerView"
	s.screenshots  = "https://raw.githubusercontent.com/hackiftekhar/IQActionSheetPickerView/master/IQActionSheetPickerView.png"
	s.license = 'MIT'
	s.author = { "Iftekhar Qurashi" => "hack.iftekhar@gmail.com" }
	s.platform = :ios, '5.0'
	s.source       = { :git => "https://github.com/hackiftekhar/IQActionSheetPickerView.git", :tag => "v1.0.2" }
	s.source_files  = 'IQActionSheetPickerView/*.{h,m}'
	s.requires_arc = true
end
