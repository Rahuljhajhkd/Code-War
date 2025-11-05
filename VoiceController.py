
# Step 1: Install packages
print("🔧 Installing packages...")
import sys
import subprocess

def install(pkg):
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "-q", pkg])
        print(f"✅ {pkg}")
    except:
        print(f"⚠️  {pkg} (skipped)")

install("SpeechRecognition")
install("pyaudio")

print("\n✅ Done!\n")

# Step 2: Import
import speech_recognition as sr
import subprocess
import platform
import webbrowser
import os

class VoiceController:
    def __init__(self):
        self.recognizer = None
        self.microphone = None
        self.is_listening = False
        self.system = platform.system()
        self.commands = {
            "open notepad": self.open_notepad,
            "open chrome": self.open_chrome,
            "open browser": self.open_chrome,
            "open my computer": self.open_file_explorer,
            "open file explorer": self.open_file_explorer,
            "open calculator": self.open_calculator,
            "open whatsapp": lambda: webbrowser.open("https://web.whatsapp.com"),
            "open gmail": lambda: webbrowser.open("https://gmail.com"),
            "open youtube": lambda: webbrowser.open("https://youtube.com"),
            "open google": lambda: webbrowser.open("https://google.com"),
            "stop listening": self.stop_listening,
            "exit": self.stop_listening,
        }
    
    def initialize_microphone(self):
        """Initialize microphone only when needed"""
        if self.recognizer is None:
            print("🎤 Initializing microphone...")
            self.recognizer = sr.Recognizer()
            self.microphone = sr.Microphone()
            print("🔊 Adjusting for noise (2 seconds)...")
            with self.microphone as source:
                self.recognizer.adjust_for_ambient_noise(source, duration=2)
            print("✅ Microphone ready!\n")
    
    def open_notepad(self):
        try:
            if self.system == "Windows":
                subprocess.Popen(["notepad.exe"])
            elif self.system == "Darwin":
                subprocess.Popen(["open", "-a", "TextEdit"])
            else:
                subprocess.Popen(["gedit"])
            print("✅ Opened Notepad")
        except Exception as e:
            print(f"❌ {e}")
    
    def open_chrome(self):
        try:
            if self.system == "Windows":
                paths = [
                    r"C:\Program Files\Google\Chrome\Application\chrome.exe",
                    r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
                ]
                for p in paths:
                    if os.path.exists(p):
                        subprocess.Popen([p])
                        print("✅ Opened Chrome")
                        return
            webbrowser.open("https://google.com")
            print("✅ Opened browser")
        except:
            webbrowser.open("https://google.com")
    
    def open_calculator(self):
        try:
            if self.system == "Windows":
                subprocess.Popen(["calc.exe"])
            else:
                subprocess.Popen(["gnome-calculator"])
            print("✅ Opened Calculator")
        except Exception as e:
            print(f"❌ {e}")
    
    def open_file_explorer(self):
        try:
            if self.system == "Windows":
                subprocess.Popen(["explorer.exe"])
            elif self.system == "Darwin":
                subprocess.Popen(["open", "."])
            else:
                subprocess.Popen(["nautilus"])
            print("✅ Opened File Explorer")
        except Exception as e:
            print(f"❌ {e}")
    
    def stop_listening(self):
        self.is_listening = False
        print("🛑 Stopped")
    
    def process_command(self, text):
        text = text.lower().strip()
        for cmd, func in self.commands.items():
            if cmd in text:
                func()
                return True
        print(f"❓ Unknown: '{text}'")
        return False
    
    def listen_once(self):
        try:
            with self.microphone as source:
                print("\n👂 Listening... SPEAK NOW!")
                audio = self.recognizer.listen(source, timeout=5, phrase_time_limit=5)
            
            print("🔄 Processing...")
            text = self.recognizer.recognize_google(audio)
            print(f"🗣️  '{text}'")
            return text
        except sr.WaitTimeoutError:
            print("⏱️  No speech")
            return None
        except sr.UnknownValueError:
            print("❌ Couldn't understand")
            return None
        except Exception as e:
            print(f"❌ {e}")
            return None
    
    def start_listening(self):
        # Initialize mic ONLY when starting
        self.initialize_microphone()
        
        self.is_listening = True
        print("\n" + "=" * 50)
        print("🎤 VOICE CONTROL ACTIVE")
        print("=" * 50)
        print("Say: 'open notepad', 'open chrome', 'open whatsapp'")
        print("Say: 'open my computer', 'stop listening'")
        print("=" * 50)
        
        while self.is_listening:
            cmd = self.listen_once()
            if cmd:
                self.process_command(cmd)
        
        print("\n✅ Stopped")

# Global
vc = None

def start_listening():
    """Start voice control"""
    global vc
    if vc is None:
        print("🚀 Creating controller...")
        vc = VoiceController()
    vc.start_listening()

def add_command(phrase, action):
    """Add custom command"""
    global vc
    if vc is None:
        vc = VoiceController()
    vc.commands[phrase.lower()] = action
    print(f"✅ Added: {phrase}")

print("""
╔════════════════════════════════════════════════════╗
║         VOICE CONTROL READY!                       ║
╚════════════════════════════════════════════════════╝

🎯 TO START: Run in new cell:
   start_listening()

📋 COMMANDS:
   • "open notepad"
   • "open chrome"
   • "open whatsapp"
   • "open my computer"
   • "open calculator"
   • "stop listening"

✅ Ready! Microphone will initialize when you start.
""")