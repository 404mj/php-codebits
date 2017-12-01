import os
import shutil

# function_name is correctly?
def get_img_type(file):
    img_type = ['bmp', 'jpeg', 'gif', 'psd', 'png', 'jpg']
    type = os.path.splitext(file)[1][1:] # see this function if you don't understand
    if type in img_type:
        return type
    else:
        return None


def resort(path):
    i=0
    photos = os.listdir(path)
    for photoname in photos:
        olddir = os.path.join(path, photoname)
        type_name = get_img_type(olddir)
        if os.path.isfile(olddir) and type_name:
            i = i + 1
            newdir = os.path.join(path,str("%03d")+'.'+type_name)%i
            print newdir
            #os.rename(olddir,newdir)
        elif os.path.isdir(olddir):
            resort(os.path.join(olddir))

    print(os.listdir(path))

def remove_file(path):
    file = os.listdir(path)
    new_file = os.path.join(path, 'output')
    if os.path.exists(new_file):
        for i in file:
            path_i = os.path.join(path,i)
            shutil.copy(path_i, new_file)
    else:
        os.mkdir(new_file)
        for i in file:
            path_i = os.path.join(path,i)
            shutil.copy(path_i, new_file)



path = '/home/users/v_zhangshuxin01/a'
resort(path)
#remove_file(path)