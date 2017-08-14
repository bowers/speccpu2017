#!/bin/bash
# Copyright 2017 Gartner, Inc.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


if [ "$1" == "-h" ] || [ "$1" == "--help" ] ; then
  cat << EOF
Usage: run.sh [options]

SPEC CPU(R) 2017 is designed to provide a comparative measure of
compute-intensive performance across the widest practical range of hardware
using workloads developed from real user applications. Metrics for both integer
and floating point compute intensive performance are provided, with both
speed and rate metrics for each. Full documentation is available on the SPEC
website: http://www.spec.org/cpu2017/.

In order to use this benchmark, SPEC CPU must be installed and the [spec_dir]/config
directory must be writable by the benchmark user. The runtime parameters
defined below essentially determine the 'runcpu' arguments.

SPEC CPU2017 consists of a total of 43 individual benchmarks divided into 4
suites: SPECspeed(R)2017 Integer, SPECspeed(R)2017 Floating Point,
SPECrate(R)2017 Integer, and SPECRate(R)2017 Floating point. Aggregate scores are
calculated for each suite by a geomean of the median results of the individual benchmarks
in that suite.



USAGE
# run 1 test iteration with some metadata
./run.sh --meta_compute_service_id aws:ec2 --meta_instance_id c3.xlarge --meta_region us-east-1 --meta_test_id aws-0914

# run with SPEC CPU 2017 installed in /usr/local/speccpu
./run.sh --spec_dir /usr/local/speccpu

# run for floating point benchmarks only
./run.sh --benchmark fp

# run for perlbench and bwaves only
./run.sh --benchmark 400 --benchmark 410


EXIT CODES:
  0 test successful
  1 test failed

SPEC CPU 2017 v1.0

SPEC CPU(R) 2017 is designed to provide a comparative measure of 
compute-intensive performance across the widest practical range of hardware 
using workloads developed from real user applications. Metrics for both integer 
and floating point compute intensive performance are provided, with both
speed and rate metrics for each. Full documentation is available on the SPEC 
website: http://www.spec.org/cpu2017/. 

In order to use this benchmark, SPEC CPU must be installed and the [spec_dir]/config 
directory must be writable by the benchmark user. The runtime parameters 
defined below essentially determine the 'runcpu' arguments.

SPEC CPU2017 consists of a total of 43 individual benchmarks divided into 4
suites: SPECspeed(R)2017 Integer, SPECspeed(R)2017 Floating Point, 
SPECrate(R)2017 Integer, and SPECRate(R)2017 Floating point. Aggregate scores are
calculated for each suite by a geomean of the median results of the individual benchmarks
in that suite.

TESTING PARAMETERS

* benchmark                  the benchmark(s) to run - any of the benchmark
                             identifiers listed in config/spec-benchmarks.ini
                             may be specified. This argument can be repeated
                             to designate multiple benchmarks. You may specify
                             'all' for all benchmarks, 'intrate' for all Integer
                             Rate benchmarks, 'intspeed' for all Integer Speed
                             benchmarks, 'fprate' for all floating point rate
                             benchmarks, 'fpspeed' for all floating point speed
                             benchmarks, or the name of a specific benchmark.
                             Benchmarks may be referenced either by their
                             numeric or full identifier (e.g. --benchmark=500
                             or --benchmark=500.perlbench_r). Additionally, you
                             may designate benchmarks that should be removed
                             by prefixing them with a minus character
                             (e.g. --benchmark=all --benchmark=-631). May also
                             be specified using a single space or comma 
                             separated value (e.g. --benchmark "all -631")
                             DEFAULT: all
                             
* collectd_rrd               If set, collectd rrd stats will be captured from 
                             --collectd_rrd_dir. To do so, when testing starts,
                             existing directories in --collectd_rrd_dir will 
                             be renamed to .bak, and upon test completion 
                             any directories not ending in .bak will be zipped
                             and saved along with other test artifacts (as 
                             collectd-rrd.zip). User MUST have sudo privileges
                             to use this option

* collectd_rrd_dir           Location where collectd rrd files are stored - 
                             default is /var/lib/collectd/rrd

* comment                    optional comment to add to the log file
                             DEFAULT: none

* config                     name of a configuration file in [spec_dir]/config 
                             to use for the run. The following macros will be 
                             automatically set via the --define argument 
                             capability of runspec (optional parameters will 
                             only be present if specified by the user):

                             rate                if this is a rate run, this 
                                                 macro will be present defining
                                                 the number of copies

                             cpu_cache:          level 2 cpu cache 
                                                 (e.g. 4096 KB)

                             cpu_count:          the number of CPU cores present

                             cpu_family:         numeric CPU family identifier

                             cpu_model:          numeric CPU model identifier

                             cpu_speed:          the nominal CPU speed in MHz 
                                                 (e.g. 2933.436)

                             cpu_speed_max:      the maximum turbo CPU speed in MHz 
                                                 (e.g. 3500.0)

                             cpu_vendor:         the CPU vendor 
                                                 (e.g. GenuineIntel)

                             compute_service_id: the compute service ID

                             external_id:        an external identifier for the 
                                                 compute resource

                             instance_id:        identifier for the compute 
                                                 resource under test 
                                                 (e.g. m1.xlarge)

                             ip_or_hostname:     IP or hostname of the compute 
                                                 resource

                             is32bit:            set if the OS is 32 bit

                             is64bit:            set if the OS is 64 bit

                             iteration_num:      the test iteration number 
                                                 (e.g. 2)

                             meta_*:             any of the meta parameters 
                                                 listed below

                             label:              user defined label for the 
                                                 compute resource

                             location:           location of the compute 
                                                 resource (e.g. CA, US)

                             memory_free:        free memory in KB

                             memory_total:       total memory in KB

                             numa:               set only if the system under
                                                 test has numa support

                             os:                 the operating system name 
                                                 (e.g. centos)

                             os_version:         the operating system version 
                                                 (e.g. 6.2)

                             provider_id:        the provider identifier 
                                                 (e.g. aws)

                             region:             compute resource region 
                                                 identifier (e.g. us-west)

                             run_id:             the benchmark run ID

                             run_name:           the name of the run (if 
                                                 assigned by the user)

                             sse:                the highest SSE flag supported

                             storage_config:     storage config identifier 
                                                 (e.g. ebs, ephemeral)

                             subregion:          compute resource subregion 
                                                 identifier (e.g. 1a)

                             test_id:            a user defined test identifier

                             x64:                set if the x64 parameter is 
                                                 also set

                             if this parameter value identifies a remote file 
                             (either an absolute or relative path on the 
                             compute resource, or an external reference like 
                             http://...) that file will be automatically copied 
                             into the [spec_dir]/config directory - if not specified,
                             a default.cfg file should be present in the config
                             directory
                             DEFAULT: none

* copies                     the number of copies to run concurrently for a rate
                             benchmark. A higher number of copies will generally produce
                             a better score (subject to resource availability for those 
                             copies to run). This parameter value may be one of 
                             the following:
            
                             cpu relative:    a percentage relative to the 
                                              number of CPU cores present. For 
                                              example, if copies=50% and the 
                                              compute instance has 4 cores, 2 
                                              copies will be run - standard 
                                              rounding will be used

                             fixed:           a simple numeric value 
                                              representing the number of copies 
                                              to run (e.g. copies=2)

                             memory relative: a memory to copies size ratio. 
                                              For example, if copies=2GB and 
                                              the compute instance has 16GB of 
                                              memory, then 8 copies will be run
                                              standard rounding will be used. 
                                              Either MB or GB suffix may be 
                                              used

                             mixed:           a combination of the above 3 types 
                                              may be used, each value separated 
                                              by a forward slash /. For example, 
                                              if copies=100%/2GB, then the number 
                                              of copies will be the lesser of 
                                              either the number of CPU cores or 
                                              memory/2GB. Alternatively, if this 
                                              value is prefixed by a +, the 
                                              greater of the values will be 
                                              used (e.g. copies=+100%/2GB)

                             The general recommend ratio of copies to resources 
                             is TBD GB of memory for 64 bit binaries,  TBD GB of 
                             memory for 32 bit binaries, 1 CPU core and TBD GB 
                             of free disk space. To specify a different number
                             of copies for 32-bit binaries versus 64-bit 
                             binaries (based on the value of the x64 parameter 
                             defined below), separate the values with a pipe, 
                             and prefix the 64-bit specified value with x64: 
                             (e.g. copies="x64:100%/2GB|100%/1GB")
                             DEFAULT: x64:100%/1GB|100%/512MB (NULL for speed runs)

* define_*                   additional macros to define using the runspec 
                             --define capability (these will be accessible in 
                             the config file using the format %{macro_name}) - 
                             any number of defines may be specified. 
                             Conditional logic within the config file is 
                             supported using the format:
																%ifdef %{macro_name}
																  # do something
																%else
																  # do something else
																%endif
                             More information is available about the use of 
                             macros on the SPEC website here: 
                             http://www.spec.org/cpu2006/Docs/config.html#sectionI.D.2
                             For flags - do not set a value for this parameter
                             (e.g. -p define_smt translates to --define smt)
                             DEFAULT: none

* delay                      Add a delay of the specified number of seconds 
                             before and after each benchmark. The delay is not 
                             counted toward the benchmark runtime.
                             DEFAULT: none

* failover_no_sse            When set to 1 in combination with an sse parameter
                             benchmark execution will be re-attempted without 
                             sse if runspec execution with sse results in an 
                             error status code (runspec will be restarted 
                             without the sse macro set)
                             DEFAULT: 0

* flagsurl                   Path to a flags file to use for the run - A flags 
                             file provides information about how to interpret 
                             and report on flags (e.g. -O5, -fast, etc.) that
                             are used in a config file. The flagsurl may be an 
                             absolute or relative path in the file system, or 
                             refer to an http accessible file
                             (e.g. $[top]/config/flags/Intel-ic17.0-official-linux64-revE.xml)
                             Alternatively, flagsurl can be defined in the 
                             config file
                             DEFAULT: none

* huge_pages                 Whether or not to enable huge pages if 
                             supported by the OS. To do so, prior to runspec
                             execution, if the file /usr/lib64/libhugetlbfs.so
                             or /usr/lib/libhugetlbfs.so exists, it then checks
                             that free huge pages are available in /proc/meminfo
                             and if these conditions are met, sets the following 
                             environment variables:
                               export HUGETLB_MORECORE=yes
                               export LD_PRELOAD=/usr/lib/libhugetlbfs.so
                             Note: In order to use huge pages, you must enable 
                             them first using something along the lines of:
                               # first clear out existing huge pages
                               echo  0 > /proc/sys/vm/nr_hugepages
                               # create 500 2MB huge pages (1GB total) - 2MB is
                               # the default huge page size on RHEL6
                               echo 500 > /proc/sys/vm/nr_hugepages
                               # mount the huge pages
                               mkdir -p /libhugetlbfs
                               mount -t hugetlbfs hugetlbfs /libhugetlbfs
                             Note: CentOS 6+ supports transparent huge pages 
                             (THP) by default. This parameter will likely have 
                             little effect on systems where THP is already 
                             enabled
                             DEFAULT: 0

* ignore_errors              whether or not to ignore errors - if 0, benchmark 
                             execution will stop if any errors occur
                             DEFAULT: 0

* iterations                 How many times to run each benchmark. This 
                             parameter should only be changed if reportable=0
                             because reportable runs must use 2 or 3 iterations
                             DEFAULT: 3 (not used if reportable=1)

* max_copies                 May be used in conjunction with dynamic copies
                             calculation (see copies parameter above) in order
                             to set a hard limit on the number of copies
                             DEFAULT: none (no limit)

* nobuild                    If 1, don't build new binaries if they do not 
                             already exist
                             DEFAULT: 1
                             
* nocleanup                  Do not delete test files generated by SPEC 
                             (i.e. [spec]/benchspec/CPU2017/[benchmark]/run/*)
                             DEFAULT: 0

* nonuma                     Do not set the 'numa' macro or invoke using 
                             'numactl --interleave=all' even if numa is 
                             supported
                             DEFAULT: 0
                             
* nosse_macro                Optional macro to define for --sse optimal if no 
                             SSE flag will be set
                             
* output                     The output directory to use for writing test 
                             artifacts. If not specified, the current working 
                             directory will be used

* purge_output               Whether or not to remote run files (created in the 
                             [spec_dir]/benchspec/CPU2017/*/run/ directories) 
                             following benchmarking completion
                             DEFAULT: 1

* rate                       Whether to execute a speed or a rate run. Per the 
                             official documentation: One way is to measure how 
                             fast the computer completes a single task; this is 
                             a speed measure. Another way is to measure how many 
                             tasks a computer can accomplish in a certain amount 
                             of time; this is called a throughput, capacity or 
                             rate measure. Automatically set if 'copies' > 1
                             DEFAULT: 1

* reportable                 whether or not to designate the run as reportable,  
                             only int, fp or all benchmarks can be designated 
                             as reportable. Per the official documentation: A 
                             reportable execution runs all the benchmarks in a 
                             suite with the test and train data sets as an 
                             additional verification that the benchmark 
                             binaries get correct results. The test and train 
                             workloads are not timed. Then, the reference 
                             workloads are run three times, so that median run 
                             time can be determined for each benchmark.
                             DEFAULT: 0

* review                     Format results for review, meaning that additional 
                             detail will be printed that normally would not be 
                             present
                             DEFAULT: 0
                             
* run_timeout                The amount of time to allow each test iteration to
                             run
                             DEFAULT: 72 hours

* size                       Size of the input data to run: test, train or ref
                             DEFAULT: ref

* spec_dir                   Directory where SPEC CPU 2017 is installed. If not 
                             specified, the benchmark run script will look up 
                             the directory tree from both pwd and --output for 
                             presence of a 'cpu2017'. If this fails, it will 
                             check '/opt/cpu2017'

* sse                        Run with a specific SSE optimization flag - if not
                             specified, the most optimal SSE flag will be used 
                             for the processor in use. The options availabe for
                             this parameter are:

                             optimal: choose the most optimal flag
                             none:    do not use SSE optimizations
                             CORE-AVX512:  AVX-512 instructions
                             CORE-AVX2:    AVX2 instructions
                             AVX:          AVX instructions
                             SSE4.2:       SSE4.2 instructions
                             SSE4.1:       SSE4.1 instructions
                             SSSE3:        SSSE3 instructions
                             SSE3:         SSE3 instructions
                             SSE2:         SSE2 instructions
                             SSE:          SSE instructions
                             DEFAULT: optimal

* sse_max                    The max SSE flag to support in conjunction with 
                             sse=optimal - if a processor supports greater than 
                             this SSE level, sse_max will be used instead
                             DEFAULT: CORE-AVX2

* sse_min                    The minimum SSE flag to support in conjunction with 
                             sse=optimal - if a processor does not at least 
                             support this SSE level sse optimization will not 
                             be used
                             DEFAULT: SSE4.2
                             
* sse_skip                   Use in conjunction with sse=optimal to skip a 
                             specific SSE flag

* tune                       Tuning option: base, peak or all - reportable runs 
                             must be either base or all
                             DEFAULT: base

* validate_disk_space        Whether or not to validate if there is sufficient 
                             diskspace available for a run - this calculation
                             is based on a minimum requirement of 2GB per copy
                             If this space is not available, the run will fail
                             DEFAULT: 1
                             
* verbose                    Show verbose output

* x64                        Optional parameter that will be passed into 
                             runspec using the macro --define x64 - this may be 
                             used to designate that a run utilize 32-bit versus 
                             64-bit binaries - this parameter can also affect 
                             the dynamic calculation of the 'copies' parameter
                             described above. Valid options are 0, 1 or 2
                             DEFAULT: 2 (64-bit binaries for 64-bit systems, 
                             32-bit otherwise)

* x64_failover               This flag will cause testing to be re-attempted
                             for the opposite x64 flag if current testing 
                             fails (e.g. if initial testing is x64=1 and it 
                             fails, then testing will be re-attempted with 
                             x64=0). When used in conjunction with 
                             failover_no_sse, sse failover will take precedence 
                             followed by x64 failover
                             DEFAULT: 0


META PARAMETERS
If set, these parameters will be included in the results generated using 
save.sh. Additionally, the parameters with a * suffix can be used to change the 
values in the SPEC CPU 2017 config file using macros. When specified, each of 
these parameters will be passed in to runcpu using 
--define [parameter_name]=[parameter_value] and will then be accessible in the 
config using macros %{parameter_name}

* meta_burst                 If set to 1, designates testing performed in burst 
                             mode (e.g. Amazon EC2 t-series burst)
                             
* meta_compiler              Details about the compiler (e.g. "Intel v16")

* meta_compute_service       The name of the compute service this test pertains
                             to. May also be specified using the environment 
                             variable bm_compute_service
                            
* meta_compute_service_id    The id of the compute service this test pertains
                             to. Added to saved results. May also be specified 
                             using the environment variable bm_compute_service_id
                            
* meta_cpu                   CPU descriptor - if not specified, it will be set 
                             using the 'model name' attribute in /proc/cpuinfo
                            
* meta_fw_bios*              Customer-orderable name and version of the system
                             firmware, sometimes called BIOS.

* meta_instance_id           The compute service instance type this test pertains 
                             to (e.g. c3.xlarge). May also be specified using 
                             the environment variable bm_instance_id
                             
* meta_hw_avail*             Date that this hardware or instance type was made 
                             available
                             
* meta_hw_nthreadspercore*   Number of hardware threads per core - DEFAULT 1

* meta_hw_other*             Any other relevant information about the instance 
                             type

* meta_hw_ocache*            Other hardware primary cache

* meta_hw_pcache*            Hardware primary cache

* meta_hw_tcache*            Hardware tertiary cache

* meta_hw_ncpuorder*         Valid number of processors orderable for this 
                             model, including a unit. (e.g. "2, 4, 6, or 
                             8 chips"
                             
* meta_license_num*          The SPEC CPU 2017 license number
                            
* meta_memory                Memory descriptor - if not specified, the system
                             memory size will be used
                             
* meta_notes_N*              General notes - all of the meta_notes_* parameters 
                             support up to 5 entries (N=1-5)
                             
* meta_notes_base_N*         Notes about base optimization options
                             
* meta_notes_comp_N*         Notes about compiler invocation

* meta_notes_os_N*           Notes about operating system tuning and changes

* meta_notes_part_N*         Notes about component parts (for kit-built systems)

* meta_notes_peak_N*         Notes about peak optimization options

* meta_notes_plat_N*         Notes about platform tuning and changes

* meta_notes_port_N*         Notes about portability options
                             
* meta_notes_submit_N*       Notes about use of the submit option
                            
* meta_os                    Operating system descriptor - if not specified, 
                             it will be taken from the first line of /etc/issue
                            
* meta_provider              The name of the cloud provider this test pertains
                             to. May also be specified using the environment 
                             variable bm_provider
                            
* meta_provider_id           The id of the cloud provider this test pertains
                             to. May also be specified using the environment 
                             variable bm_provider_id
                            
* meta_region                The compute service region this test pertains to. 
                             May also be specified using the environment 
                             variable bm_region
                            
* meta_resource_id           An optional benchmark resource identifiers. May 
                             also be specified using the environment variable 
                             bm_resource_id
                            
* meta_run_id                An optional benchmark run identifiers. May also be 
                             specified using the environment variable bm_run_id
                            
* meta_storage_config        Storage configuration descriptor. May also be 
                             specified using the environment variable 
                             bm_storage_config
                             
* meta_sw_avail*             Date that the OS image was made available

* meta_sw_other*             Any other relevant information about the software
                            
* meta_test_id               Identifier for the test. May also be specified 
                             using the environment variable bm_test_id
                             
                             
DEPENDENCIES
This benchmark has the following dependencies:

 SPEC CPU 2017               This benchmark is licensed by spec.org. To use 
                             this benchmark harness you must have it installed
                             and available in the 'spec_dir' directory
 perl                        Used by SPEC CPU 2017
 php-cli                     Test automation scripts (/usr/bin/php)
 zip                         Used to compress test artifacts
 
 
USAGE
# run 1 test iteration with some metadata
./run.sh --meta_compute_service_id aws:ec2 --meta_instance_id c3.xlarge --meta_region us-east-1 --meta_test_id aws-0914

# run with SPEC CPU 2017 installed in /usr/local/speccpu
./run.sh --spec_dir /usr/local/speccpu

# run for floating point benchmarks only
./run.sh --benchmark fp

# run for perlbench and bwaves only
./run.sh --benchmark 500 --benchmark 505

# save.sh saves results to CSV, MySQL, PostgreSQL, BigQuery or via HTTP 
# callback. It can also save artifacts (text report ) to S3, Azure Blob Storage
# or Google Cloud Storage

# save results to CSV files
./save.sh

# save results from 5 iterations text example above
./save.sh ~/spec-testing

# save results to a PostgreSQL database
./save --db postgresql --db_user dbuser --db_pswd dbpass --db_host db.mydomain.com --db_name benchmarks

# save results to BigQuery and artifact (TRIAD gnuplot PNG image) to S3
./save --db bigquery --db_name benchmark_dataset --store s3 --store_key THISIH5TPISAEZIJFAKE --store_secret thisNoat1VCITCGggisOaJl3pxKmGu2HMKxxfake --store_container benchmarks1234

EOF
  exit
elif [ -f "/usr/bin/php" ] && [ -f "/usr/bin/perl" ]; then
  $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/lib/run.php $@
  exit $?
else
  echo "Error: missing dependency php-cli (/usr/bin/php) or perl (/usr/bin/perl)"
  exit 1
fi
