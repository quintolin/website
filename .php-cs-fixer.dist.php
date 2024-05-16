<?php

declare(strict_types=1);

use PhpCsFixer\Config;
use PhpCsFixer\Finder;
use Quintolin\CodingStandard\PhpCsFixerRulesFactory;

require_once 'vendor/autoload.php';

$factory = new PhpCsFixerRulesFactory();
$rules = $factory->create();

$finder = Finder::create();
$finder->files();
$finder->in(dirs: __DIR__);
$finder->exclude(dirs: ['var', 'vendor']);
$finder->append(iterator: [__FILE__, __DIR__ . '/bin/console']);

$config = new Config(name: 'Quintolin');
$config->setFinder(finder: $finder);
$config->setRiskyAllowed(isRiskyAllowed: true);
$config->setRules(rules: $rules);

return $config;
