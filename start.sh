#!/data/data/com.termux/files/usr/bin/bash
echo "Memulai instalasi PHP di Termux..."
pkg update -y && pkg upgrade -y
pkg install -y php nano

php -v

# Membuat file osist.php
cat > osist.php << 'EOF'
<?php
system("clear");

function gradientText($text) {
    $colors = [36, 32]; // ANSI color codes for cyan (tosca) and green
    $coloredText = "";
    $lines = explode("\n", $text);
    
    foreach ($lines as $line) {
        $colorIndex = 0;
        $chars = str_split($line);
        
        foreach ($chars as $char) {
            $coloredText .= "\033[" . $colors[$colorIndex % count($colors)] . "m" . $char . "\033[0m";
            $colorIndex++;
        }
        $coloredText .= "\n";
    }
    
    return $coloredText;
}

$asciiArt = "
           _     _    
  ___  ___(_)___| |_  
 / _ \/ __| / __| __| 
| (_) \__ \ \__ \ |_  
 \___/|___/_|___/\__| 
                      
  Tools by Feri - Versi 1.0.1
";

echo gradientText($asciiArt) . "\n";

do {
    echo "\033[32mMasukkan request: \033[0m";
    $request = trim(fgets(STDIN));
    
    $data = [
        "token" => "7091284941:4PND5eXU",
        "request" => $request,
        "limit" => 100,
        "lang" => "id"
    ];

    $url = 'https://leakosintapi.com/';

    $options = [
        "http" => [
            "header" => "Content-Type: application/json\r\n",
            "method" => "POST",
            "content" => json_encode($data)
        ]
    ];

    $context = stream_context_create($options);
    $response = file_get_contents($url, false, $context);

    if ($response === FALSE) {
        echo "Gagal mendapatkan respons dari API.\n";
    } else {
        $body = json_decode($response, true);

        if (!isset($body["List"])) {
            echo "Format respons API tidak sesuai.\n";
        } else {
            foreach ($body["List"] as $databaseName => $info) {
                $text = "\n\033[36m<b>$databaseName</b>\033[0m\n\n";
                $text .= $info["InfoLeak"] . "\n\n";
                
                if ($databaseName !== "No results found") {
                    foreach ($info["Data"] as $reportData) {
                        foreach ($reportData as $columnName => $value) {
                            $text .= "\033[32m<b>$columnName</b>\033[0m: $value\n";
                        }
                        $text .= "\n";
                    }
                }
                
                echo $text;
            }
        }
    }
    
    echo "\033[32mIngin menjalankan kembali? (y/n): \033[0m";
    $ulang = trim(fgets(STDIN));
    if (strtolower($ulang) === "y") {
        echo "\033[32mSiap bos!\033[0m\n";
        system("clear");
    }
} while (strtolower($ulang) === "y");
EOF

# Menjalankan script PHP
php osist.php
