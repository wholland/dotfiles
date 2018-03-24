function mt_cmake_mobile_generate
    mkdir -p $MT_BUILD; and mt_cmake_ios all_mobile; return $status
end
