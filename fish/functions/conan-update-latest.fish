function conan-update-latest
    set -l conan_name conan-latest
    set -lx CONAN_USER_HOME "~/.$conan_name/"
    vf activate $conan_name
    pip install -U conan
    vf deactivate
    run-conan latest --version
end

