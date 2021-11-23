class RLEdecoder {
  String rle_string;
  String name;
  String author;
  int rows, cols;
  ArrayList<Integer> birth_rules, survival_rules;
  String raw_pattern;
  
  RLEdecoder(String rle) {
    // println("Constructor Called");
    rle_string = rle;
    name = author = "";
    rows = cols = 0;
    raw_pattern = "";
    birth_rules = new ArrayList<Integer>();
    survival_rules = new ArrayList<Integer>();
  }
  
  void print() {
    println("decoder.rows = ", decoder.rows);
    println("decoder.cols = ", decoder.cols);
    println("decoder.name = ", decoder.name);
    println("decoder.author = ", decoder.author);
    println("decoder.birth_rules = ", decoder.birth_rules);
    println("decoder.survival_rules = ", decoder.survival_rules);
  }
  
  int[][] get_pattern() {
    // println("Get Pattern Called");
    parse_rle();
    // println("rows = ", rows, " cols = ", cols);
    int[][] pattern = new int[rows][cols]; 
    for (int i = 0; i < rows; ++i) {
      for (int j = 0; j < cols; ++j) {
        pattern[i][j] = 0;  
      }
    }
    String[] pattern_rows = split(raw_pattern.replaceAll("!", ""), '$');
     //println("pattern_rows.length() = ", pattern_rows.length);
    int row_idx = 0;
    for (int idx = 0; idx < pattern_rows.length; ++idx) {
      String p = pattern_rows[idx];
      // println("p.length() = ", p.length());
       //println("p = ", p);
      String temp = "";
      int num_cells, start = 0;
      for (int i = 0; i < p.length(); ++i) {
        if (Character.isDigit(p.charAt(i))) {
          temp += p.charAt(i);
        }
        else {
          if (temp == "") {
             num_cells = 1;
          }
          else {
            num_cells = int(temp);
          }
          // println("num_cells = ", num_cells);
          for (int j = 0; j < num_cells; ++j) {
            pattern[row_idx][start + j] = int(p.charAt(i) == 'o'); 
          }
          temp = "";
          
          start += num_cells;
        }
      }
      
      if (Character.isDigit(p.charAt(p.length() - 1))) {
        String tmp = "";
        int j = p.length() - 1;
        while (Character.isDigit(p.charAt(j))) {
          tmp = p.charAt(j) + tmp;
          --j;
        }
        int last = int(tmp);
        row_idx += last;
      } else {
        row_idx++;
      }
    }
    
    return pattern;
  }
  
  void parse_rle() {
    // println("Parser Called");
    String[] lines = split(rle_string.strip(), "\n");
    for (String line : lines) {
      
      if (line.charAt(0) == 'x') {
        String[] data = split(line.strip(), ", ");
        for (String d : data) {
          d = d.stripLeading().stripTrailing();
          // println("d = ", d);
          String[] sz = split(d, "=");
          if (d.charAt(0) == 'x') {
             cols = int(sz[1].strip());
          }
          else if (d.charAt(0) == 'y') {
             rows = int(sz[1].strip());
          }
          else if (d.substring(0, 4).equals("rule")) {
            // println("inside", d);
            String[] rules = split(sz[1], "/");
            for (String rule : rules) {
              rule = rule.strip();
              // println("rule", rule);
              // println("len = ", rule.length());
              if (Character.toUpperCase(rule.charAt(0)) == 'B') {
                for (int i = 1; i < rule.length(); ++i) {
                  // println("i = ", i);
                  int no = Character.digit(rule.charAt(i), 10);
                  // println(no);
                  birth_rules.add(no);
                  // println("ooo");
                }
                // println("Over");               
              }
              else if (Character.toUpperCase(rule.charAt(0)) == 'S') {
                for (int i = 1; i < rule.length(); ++i) {
                  // println(rule.charAt(i));
                  int no = Character.digit(rule.charAt(i), 10);
                  survival_rules.add(no);
                }
              }
            }
          }         
        }
      }
      
      // here..
      else if (!line.substring(0, 2).equals("#N") && !line.substring(0, 2).equals("#C") && !line.substring(0, 2).equals("#O")) {
        // println("line = ", line);
        raw_pattern += line.strip();
        
      }
    }
  }
}
