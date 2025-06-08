@echo off
setlocal enabledelayedexpansion

echo 🔄 Starting Stable Fast 3D Offline Installer...

:: Load environment variables from setup.env
for /f "tokens=1,2 delims==" %%a in (setup.env) do (
    set %%a=%%b
)

:: Step 1: Setup Python virtual environment
echo 📦 Setting up Python virtual environment...
python%PYTHON_VERSION% -m venv %VENV_NAME%

:: Activate virtual environment
call %VENV_NAME%\Scripts\activate.bat

:: installing pytorch and torchvision
pip install torch torchvision

:: Step 2: Upgrade pip and install build tools
echo ⬆️  Upgrading pip and installing build tools...
pip install --no-index --find-links=offline_packages pip setuptools==69.5.1 wheel

:: Step 3: Install main requirements
echo 📂 Installing main project dependencies...
pip install --no-index --find-links=offline_packages -r stable-fast-3d\requirements.txt

:: Step 4: Install Gradio requirements
pip install --no-index --find-links=offline_packages -r stable-fast-3d\requirements-demo.txt

:: Step 5: Hugging Face login
if "%HF_TOKEN%"=="" (
    set /p HF_TOKEN=🔐 Please enter your Hugging Face token (read access):
)
huggingface-cli login --token %HF_TOKEN%

echo ✅ Installation complete!
echo.
echo 👉 To test the app, run:
echo    call %VENV_NAME%\Scripts\activate.bat
echo    python run.py demo_files/examples/chair1.png --output-dir output/
echo    if the above command show any error like 'RuntimeError: Invalid buffer size: 5.09 GB' then run the following command:
echo    SF3D_USE_CPU=1 python run.py demo_files/examples/chair1.png --output-dir output/
echo    or start Gradio UI: python gradio_app.py

pause
