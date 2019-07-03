#! /bin/bash

set -eo pipefail

echo "Cloning repo for Mask-RCNN"
git clone https://github.com/facebookresearch/maskrcnn-benchmark

echo "Installing various utils"
pip install -U ninja yacs cython opencv-python ipython numpy matplotlib seaborn googledrivedownloader

echo "Installing pytorch and cloned project's requirements"
pip install -U torch torchvision pycocotools

echo "Installing cloned project"
(cd maskrcnn-benchmark && python setup.py install)
cp maskrcnn-benchmark/demo/predictor.py ./


echo "Getting small images sets from Google Drive (~200M)"
FILE_URL="1JobDsYJOpaPmeY8mQWUAUIq0bBo-uoJs"
FILE_NAME="image_sets"

mkdir -p local_data
python -c "from google_drive_downloader import GoogleDriveDownloader as gdd; gdd.download_file_from_google_drive(file_id='$FILE_URL', dest_path='./local_data/$FILE_NAME.tar.gz', unzip=False)"

echo "Decompressing archive"
(cd local_data && tar -xzf "$FILE_NAME".tar.gz --no-same-owner)


echo "Getting example results from Google Drive (~100M)"
FILE_URL="1VR4UPp-yTLSIwp000RrSXCkyT8c2A_-R"
FILE_NAME="results"

mkdir -p results
python -c "from google_drive_downloader import GoogleDriveDownloader as gdd; gdd.download_file_from_google_drive(file_id='$FILE_URL', dest_path='./results/$FILE_NAME.tar.gz', unzip=False)"

echo "Decompressing archive"
(cd results && tar -xzf "$FILE_NAME".tar.gz --no-same-owner)

echo
echo "~~~"
echo "Installed all requirements"
echo "~~~"
echo

read -p "Launch jupyter notebook now? ([y]/n)" -n 1 -r
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo "Launching jupyter notebook"
    jupyter notebook
fi
echo

exit 0
