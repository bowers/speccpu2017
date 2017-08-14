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
 * gets results from SPEC CPU2017 csv files and renders them as [key]=[value]
 * pairs (1 per line of output). If both base and peak results exist, 
 * [key]1=[value] will be for base and [key]2=[value] will be for peak
 */
require_once(dirname(__FILE__) . '/SpecCpu2017Test.php');

$status = 1;
$dir = count($argv) > 1 && is_file($argv[count($argv) - 1]) ? dirname($argv[count($argv) - 1]) : trim(shell_exec('pwd'));
$test = new SpecCpu2017Test($dir);
$options = parse_args(array('v' => 'verbose'));
$rows = array();
if ($results = $test->getResults(TRUE, isset($options['verbose']))) $rows[] = $results;
if ($results = $test->getResults(FALSE, isset($options['verbose']))) $rows[] = $results;
foreach($rows as $i => $results) {
  $status = 0;
  $suffix = count($rows) > 1 ? $i + 1 : '';
  foreach($results as $key => $val) printf("%s%s=%s\n", $key, $suffix, $val);
}

exit($status);
?>
