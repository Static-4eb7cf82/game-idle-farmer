extends Crop
# Bug:
# When all the crops referenced Crop.gd as their script, planting a crop other than wheat would be nil
# But when I first implemented this and had the crops share this script, it worked fine