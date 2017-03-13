
#!/bin/bash
set -eu -o pipefail

PKG_HOME=$PREFIX/share/$PKG_NAME-$PKG_VERSION-$PKG_BUILDNUM
PKG_bin=$PREFIX/bin

mkdir -p $PKG_HOME
mkdir -p $PKG_bin

cp -r  * $PKG_HOME/.

params_reader=$PKG_HOME/params_reader.rb
run_motif_discovery=$PKG_HOME/run_motif_discovery.rb
fasta_format_reader=$PKG_HOME/fasta_format_reader.rb
generate_filelist_files=$PKG_HOME/generate_filelist_files.rb
params=$PKG_HOME/params/io.params
covariates=$PKG_HOME/covariates.params
executable_template=$PKG_HOME/run_cERMIT_executable_template
cERMIT=$PKG_HOME/cERMIT
run_all=$PKG_HOME/run_all

sed -i  's|./params_reader.rb|'$params_reader'|' $fasta_format_reader

sed -i  's|./params_reader.rb|'$params_reader'|' $generate_filelist_files

sed -i  's|run_cERMIT_executable_template|'$executable_template'|' $run_motif_discovery
sed -i  's|./params_reader.rb|'$params_reader'|' $run_motif_discovery
sed -i 's|system("./#{run_file_name}")|system("bash #{run_file_name}")|'  $run_motif_discovery
sed -i 's|system("cp #{|#system("cp #{|' $run_motif_discovery

sed -i 's|run_file_template=run_cERMIT_executable_template||' $params
sed -i 's|covariates_params_file=params/covariates.params|covariates_params_file='$covariates'|' $params

sed -i 's|executable=./cERMIT|executable='$cERMIT'|' $executable_template
sed -i 's|in_seeds_file=./oligos_size_"$seed_length"|in_seeds_file='$PKG_HOME'/oligos_size_"$seed_length"|' $executable_template

sed -i  's|io_params_filename=params/io.params|io_params_filename=$1|' $run_all
sed -i  's|./fasta_format_reader.rb|'$fasta_format_reader'|' $run_all
sed -i  's|./generate_filelist_files.rb|'$generate_filelist_files'|' $run_all
sed -i  's|./run_motif_discovery.rb|'$run_motif_discovery'|' $run_all
sed -i "9i if [ \$# -eq 0 ] ; then echo 'Pealse speciy input params'; exit 1; fi" $run_all
sed -i  "10i if ! [ -e \$io_params_filename ] ; then echo \$io_params_filename' does not exsit'; exit 1; fi" $run_all
sed -i "11i if ! [ -L  generate_logo.R ]; then ln -s $PKG_HOME/generate_logo.R .; fi" $run_all
echo 'if [ -L  generate_logo.R ]; then rm generate_logo.R; fi' >> $run_all

chmod +x $run_all
chmod +x $run_motif_discovery
chmod +x $fasta_format_reader
chmod +x $generate_filelist_files

cERMIT_params=$PKG_HOME'/cermit_params'
echo 'cp '$params' .' > $cERMIT_params
echo 'echo "generated parameter template: io.params"' >> $cERMIT_params
chmod +x $cERMIT_params

ln -s $run_all $PKG_bin/run_cermit
ln -s $cERMIT_params $PKG_bin/cermit_params
