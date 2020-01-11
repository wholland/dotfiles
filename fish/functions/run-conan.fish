function run-conan
	set -l conan_version $argv[1]
    set -l conan_name conan-$conan_version
    set -lx CONAN_USER_HOME "~/.$conan_name/"
    echo "Running conan $conan_version."
    echo "Executable: ~/.virtualenvs/$conan_name/bin/conan"
    echo "User Home: $CONAN_USER_HOME"
    ~/.virtualenvs/$conan_name/bin/conan $argv[2..-1]
end
