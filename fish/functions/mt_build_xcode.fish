function mt_build_xcode
    set -l scheme $argv[0]
    set -l config $argv[1]
    xcodebuild -project {$MT_BUILD}Project.xcodeproj -scheme $scheme -configuration $config build
end
