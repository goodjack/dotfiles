# README

## PHP CS FIXER

規則為 PSR12 preset 和 [Laravel preset](https://github.com/laravel/pint/blob/main/resources/presets/laravel.php) 的合體。
以 [PHP-CS-Fixer configuration 3.18.0](https://mlocati.github.io/php-cs-fixer-configurator/#version:3.18) 比對兩者差異後，將特殊規則處理記錄在下方。

### 衝突規則：以 PSR12 為優先

```php
[
    'concat_space' => [
        'spacing' => 'one',
    ],
    'method_argument_space' => [
        'on_multiline' => 'ensure_fully_multiline'
    ],
    'single_class_element_per_statement' => [
        'elements' => [
            'const',
            'property',
        ],
    ],
    'single_import_per_statement' => true,
]
```

### 合併規則：將兩者合併為更嚴謹的擴充規則

```php
[
    'class_definition' => [
        'inline_constructor_arguments' => false,
        'multi_line_extends_each_single_line' => true,
        'single_item_single_line' => true,
        'single_line' => true,
        'space_before_parenthesis' => true
    ],
    'curly_braces_position' => [
        'control_structures_opening_brace' => 'same_line',
        'functions_opening_brace' => 'next_line_unless_newline_at_signature_end',
        'anonymous_functions_opening_brace' => 'same_line',
        'classes_opening_brace' => 'next_line_unless_newline_at_signature_end',
        'anonymous_classes_opening_brace' => 'next_line_unless_newline_at_signature_end',
        'allow_single_line_empty_anonymous_classes' => false,
        'allow_single_line_anonymous_functions' => false
    ],
    'ordered_imports' => [
        'imports_order'=>[
            'class',
            'function',
            'const'
        ],
        'sort_algorithm' => 'alpha'
    ],
]
```