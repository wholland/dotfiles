function mt_build_mobile
    mt_cmake_mobile_generate
    and xcodebuild -project {$MT_BUILD}Project.xcodeproj -scheme $argv -configuration Release build | xcpretty
end
