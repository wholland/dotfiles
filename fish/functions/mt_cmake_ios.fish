function mt_cmake_ios
    set BUILD_GROUP $argv 
    pushd $MT_BUILD
    cmake -DCMAKE_TOOLCHAIN_FILE={$MT_BASELINE}cmake/ios_toolchain.cmake \
        -DIOS_PLATFORM=OS \
        -Dbuild=$BUILD_GROUP \
        -BXcode -GXcode \
        $MT_BASELINE
    set -l cmakestatus $status
    popd
    return $cmakestatus
end
