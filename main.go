package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
)

var version = "dev" // will be overridden during build

func askYesNo(question string, defaultNo bool) bool {
	reader := bufio.NewReader(os.Stdin)
	fmt.Print(question + " ")
	text, _ := reader.ReadString('\n')
	text = strings.TrimSpace(strings.ToLower(text))

	if text == "" {
		return !defaultNo
	}
	return text == "y" || text == "yes"
}

func flattenFolder(source string) error {
	absSource, err := filepath.Abs(source)
	if err != nil {
		return err
	}

	info, err := os.Stat(absSource)
	if os.IsNotExist(err) {
		return fmt.Errorf("❌ no folder found: %s", absSource)
	}
	if !info.IsDir() {
		return fmt.Errorf("❌ '%s' is not a folder", absSource)
	}

	baseName := filepath.Base(absSource)
	destFolder := fmt.Sprintf("flatten_%s", baseName)

	counter := 0
	for {
		if _, err := os.Stat(destFolder); os.IsNotExist(err) {
			break // folder doesn't exist, safe to use
		}

		if !askYesNo(fmt.Sprintf("⚠️  folder '%s' already exists. Overwrite? (y/N):", destFolder), true) {
			counter++
			destFolder = fmt.Sprintf("flatten_%s_%d", baseName, counter)
			continue
		} else {
			break // overwrite
		}
	}

	os.MkdirAll(destFolder, 0755)

	fmt.Printf("📂 Collecting files from: %s\n", absSource)
	fmt.Printf("📦 Saving to: %s\n", destFolder)

	count := 0
	err = filepath.Walk(absSource, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if !info.Mode().IsRegular() {
			return nil
		}

		destPath := filepath.Join(destFolder, info.Name())

		if _, err := os.Stat(destPath); err == nil {
			ext := filepath.Ext(info.Name())
			name := strings.TrimSuffix(info.Name(), ext)
			i := 1
			for {
				newName := fmt.Sprintf("%s_%d%s", name, i, ext)
				destPath = filepath.Join(destFolder, newName)
				if _, err := os.Stat(destPath); os.IsNotExist(err) {
					break
				}
				i++
			}
		}

		srcFile, err := os.Open(path)
		if err != nil {
			return err
		}
		defer srcFile.Close()

		destFile, err := os.Create(destPath)
		if err != nil {
			return err
		}
		defer destFile.Close()

		_, err = io.Copy(destFile, srcFile)
		if err != nil {
			return err
		}

		count++
		return nil
	})

	if err != nil {
		return err
	}

	fmt.Printf("✅ Done! %d files copied to %s\n", count, destFolder)
	return nil
}

func main() {
	if len(os.Args) == 2 && (os.Args[1] == "--version" || os.Args[1] == "-v") {
		fmt.Printf("flatten version %s\n", version)
		os.Exit(0)
	}

	if len(os.Args) != 2 {
		fmt.Println("❌ Error: only one folder is allowed.")
		fmt.Println("Usage: flatten <folder_path>")
		fmt.Println("       flatten --version")
		os.Exit(1)
	}

	err := flattenFolder(os.Args[1])
	if err != nil {
		fmt.Println("Error:", err)
		os.Exit(1)
	}
}
