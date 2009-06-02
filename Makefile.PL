use inc::Module::Install;

perl_version '5.8.1';
name 'String-Dictionary';

all_from 'lib/String/Dictionary.pm';

requires 'perl' => '5.8.1';
requires 'Exporter::Lite';

auto_install;
WriteAll;
