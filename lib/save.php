#!/usr/bin/php -q
<?php
// Copyright 2017 Gartner, Inc.
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// 
//     http://www.apache.org/licenses/LICENSE-2.0
// 
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


/**
 * saves results based on the arguments defined in ../run.sh
 */
require_once(dirname(__FILE__) . '/SpecCpu2017Test.php');
require_once(dirname(__FILE__) . '/save/BenchmarkDb.php');
$status = 1;
$args = parse_args(array('iteration:', 'nostore_csv', 'nostore_html', 'nostore_pdf', 'nostore_rrd', 'nostore_text', 'v' => 'verbose'));

// get result directories => each directory stores 1 iteration of results
$dirs = array();
$dir = count($argv) > 1 && is_dir($argv[count($argv) - 1]) ? $argv[count($argv) - 1] : trim(shell_exec('pwd'));
if (is_dir(sprintf('%s/1', $dir))) {
  $i = 1;
  while(is_dir($sdir = sprintf('%s/%d', $dir, $i++))) $dirs[] = $sdir;
}
else $dirs[] = $dir;

if ($db =& BenchmarkDb::getDb()) {
  $rows = 0;
  // get results from each directory
  foreach($dirs as $i => $dir) {
    $test = new SpecCpu2017Test($dir);
    $iteration = isset($args['iteration']) && preg_match('/([0-9]+)/', $args['iteration'], $m) ? $m[1]*1 : $i + 1;
    // save artifacts
    print_msg(sprintf('Saving results in directory %s', $dir), isset($args['verbose']), __FILE__, __LINE__);
    foreach(array('specfp2017.csv' => 'nostore_csv', 'specfp2017.html' => 'nostore_html', 'specfp2017.pdf' => 'nostore_pdf', 'specfp2017.txt' => 'nostore_text', 
                  'specint2017.csv' => 'nostore_csv', 'specint2017.html' => 'nostore_html', 'specint2017.pdf' => 'nostore_pdf',
                  'collectd-rrd.zip' => 'nostore_rrd', 'specint2017.txt' => 'nostore_text') as $file => $arg) {
      $file = sprintf('%s/%s', $dir, $file);
      if (!isset($args[$arg]) && file_exists($file)) {
        $pieces = explode('.', $file);
        $type = $pieces[count($pieces) - 1];
        $col = $arg == 'nostore_rrd' ? 'collectd_rrd' : sprintf('spec%s_%s', preg_match('/specfp/', basename($file)) ? 'fp' : 'int', $type == 'txt' ? 'text' : $type);
        $saved = $db->saveArtifact($file, $col);
        if ($saved) print_msg(sprintf('Saved %s successfully', basename($file)), isset($args['verbose']), __FILE__, __LINE__);
        else if ($saved === NULL) print_msg(sprintf('Unable to save %s', basename($file)), isset($args['verbose']), __FILE__, __LINE__, TRUE);
        else print_msg(sprintf('Artifact %s will not be saved because --store was not specified', basename($file)), isset($args['verbose']), __FILE__, __LINE__);
      }
      else if (file_exists($file)) print_msg(sprintf('Artifact %s will not be saved because --%s was set', basename($file), $arg), isset($args['verbose']), __FILE__, __LINE__);
      else print_msg(sprintf('Artifact %s is missing', $file), isset($args['verbose']), __FILE__, __LINE__);
    }
    // get results
    foreach(array(TRUE, FALSE) as $base) {
      if ($results = $test->getResults($base, isset($args['verbose']))) {
        $results['iteration'] = $iteration;
        if ($db->addRow('speccpu2017', $results)) {
          print_msg(sprintf('Successfully saved %s test results', $base ? 'base' : 'peak'), isset($args['verbose']), __FILE__, __LINE__);
          $rows++;
        }
        else print_msg(sprintf('Failed to save test results'), isset($args['verbose']), __FILE__, __LINE__, TRUE);
      }
      else print_msg(sprintf('Unable to save %s results in directory %s - are result files present?', $base ? 'base' : 'peak', $dir), isset($args['verbose']), __FILE__, __LINE__);
    }
  }
  
  // finalize saving of results
  if (!$rows) print_msg(sprintf('Unable to save test results - no results were found in %s', implode('; ', $dirs)), isset($args['verbose']), __FILE__, __LINE__, TRUE);
  else if ($db->save()) {
    print_msg(sprintf('Successfully saved test results from directories %s', implode('; ', $dirs)), isset($args['verbose']), __FILE__, __LINE__);
    $status = 0;
  }
  else {
    print_msg(sprintf('Unable to save test results from directories %s', implode('; ', $dirs)), isset($args['verbose']), __FILE__, __LINE__, TRUE);
    $status = 1;
  }
}

exit($status);
?>
