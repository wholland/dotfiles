function get-conan
    set -l conan_version $argv[1]
    set -l conan_name conan-$conan_version
    set -lx CONAN_USER_HOME ~/.$conan_name/
    vf new $conan_name
    vf activate $conan_name
    pip install conan==$conan_version
    vf deactivate
    run-conan $conan_version --version
end
