
#!/bin/bash

params_reader=$PREFIX/params_reader.rb
run_motif_discovery=$PREFIX/run_motif_discovery.rb
fasta_format_reader=$PREFIX/fasta_format_reader.rb
generate_filelist_files=$PREFIX/generate_filelist_files.rb
params=$PREFIX/params/io.params
covariates=$PREFIX/covariates.params
executable_template=$PREFIX/run_cERMIT_executable_template
cERMIT=$PREFIX/cERMIT
run_all=$PREFIX/run_all

sed -i  's|./params_reader.rb|'$params_reader'|' $fasta_format_reader

sed -i  's|./params_reader.rb|'$params_reader'|' $generate_filelist_files

sed -i  's|run_cERMIT_executable_template|'$executable_template'|' $run_motif_discovery
sed -i  's|./params_reader.rb|'$params_reader'|' $run_motif_discovery
sed -i 's|system("./#{run_file_name}")|system("bash #{run_file_name}")|'  $run_motif_discovery
sed -i 's|system("cp #{|#system("cp #{|' $run_motif_discovery

sed -i 's|run_file_template=run_cERMIT_executable_template||' $params
sed -i 's|covariates_params_file=params/covariates.params|covariates_params_file='$covariates'|' $params

sed -i 's|executable=./cERMIT|executable='$cERMIT'|' $executable_template
sed -i 's|in_seeds_file=./oligos_size_"$seed_length"|in_seeds_file='$PREFIX'/oligos_size_"$seed_length"|' $executable_template

sed -i  's|io_params_filename=params/io.params|io_params_filename=$1|' $run_all
sed -i  's|./fasta_format_reader.rb|'$fasta_format_reader'|' $run_all
sed -i  's|./generate_filelist_files.rb|'$generate_filelist_files'|' $run_all
sed -i  's|./run_motif_discovery.rb|'$run_motif_discovery'|' $run_all
sed -i "9i if [ \$# -eq 0 ] ; then echo 'Pealse speciy input params'; exit 1; fi" $run_all
sed -i  "10i if ! [ -e \$io_params_filename ] ; then echo \$io_params_filename' does not exsit'; exit 1; fi" $run_all
sed -i "11i if ! [ -L  generate_logo.R ]; then ln -s $PREFIX/generate_logo.R .; fi" $run_all
echo 'if [ -L  generate_logo.R ]; then rm generate_logo.R; fi' >> $run_all

chmod +x $run_all
chmod +x $run_motif_discovery
chmod +x $fasta_format_reader
chmod +x $generate_filelist_files

PREFIX_bin=$PREFIX/bin
cERMIT_params=$PREFIX_bin'/cERMIT_params'
echo 'cp '$params' .' > $cERMIT_params
chmod +x $cERMIT_params

ln -s $run_all $PREFIX_bin/run_cERMIT
