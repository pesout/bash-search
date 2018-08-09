# Bash-search project
Grep-based recursive search with better-looking output

### Supported systems
- Linux, Solaris

### Features
- **options**
  - `-i` case insensitive
  - `-v` invert match

- **queries**
  - regular expressions
  - OR

### Usage
- `chmod 777 search.sh`
- `./search.sh [-i] [-v] LOCATION QUERY`

### Example input
```
./search.sh  workspace   hello.*rld[or]goodbye
./search.sh  /tmp/  ".*2018.log"
./search.sh  -iv  ..  abcd [or] defg
```

### Example output
```
../workspace/export/.project
      10:  <arguments>
      15:  <arguments>
../workspace/export/build.xml
      52:  <arg value="install" />
../workspace/cetelem-export-danube/renderer/build.xml
      2:   <attribute name="Author" value="${author.name}" />
      24:  <attribute name="Built-By" value="${user.name}" />
      27:  <attribute name="Implementation-Version" value="1.0" />
      
5 found
```
