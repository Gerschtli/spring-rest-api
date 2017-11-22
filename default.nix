with import <nixpkgs> { };

releaseTools.mvnBuild rec {
  name = "spring-rest-api";

  src = ./.;

  buildInputs = [
    jdk
    makeWrapper
    maven
  ];

  doTest = false;

  doTestCompile = false;

  mvnJar = ''
    mvn package -Dmaven.repo.local=$M2_REPO
  '';

  mvnAssembly = ''
    true # do nothing
  '';

  mvnRelease = ''
    mkdir -p $out/share/java $out/bin

    cp target/*.jar $out/share/java/${name}.jar

    makeWrapper ${jre_headless}/bin/java $out/bin/${name} \
      --add-flags "-jar $out/share/java/${name}.jar"
  '';
}
