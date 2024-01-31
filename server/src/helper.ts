import { join } from 'path';
import { FileFieldsInterceptor, FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { of } from 'rxjs';
 
/**
 * Variable tipo 'const' para poder cambiar el nombre de archivo con las fecha de subida
 * @param req The Express Request object.
 * @param file Object containing information about the processed file.
 * @param cb Callback to determine the destination path.
 **/
export const changeImgName = (req, img, cb) => {
  const imgName = img.originalname.toLowerCase().match(/^(.+)(jpg|jpeg|png|gif|webp|jfif)$/);
  cb(null, (imgName[1] + '-' + Date.now() + '.' + imgName[2]))
}
 
/**
 * Variable tipo 'const' para poder filtrar el archivo para solo permitir archivos que sean imagenes
 * @param req The Express Request object.
 * @param file Object containing information about the processed file.
 * @param cb Callback to determine the destination path.
 **/
export const typeAccepted = (req, img, cb) => {
  if (!img.originalname.toLowerCase().match(/\.(jpg|jpeg|png|gif|webp|jfif)$/)) {
    return cb(new Error('Img format type invalid'), false);
  }
  cb(null, true);
}
 
/**
 * Variable tipo 'const' para poder retornar los imgenes solicitados de la peticion
 * @Res response The Express Response object
 * @Path location The Express Path location for get img ubicacion;
 **/
 
export const getImageObject = (file, res) => {
  return of(res.sendFile(join(process.cwd(), `uploads/${file}`)));
}
 
/**
 * Variable tipo 'const' este variable se encarga de inceptar con el fichero "img, txt, o otros" despues
 * de siertas verificacion procede a guardar el fichero en la carpeta Uploads
 * @File is name of @Key for member upload de file but with this express using file name with the key.
 **/
export const sizeFile = (1024 * 1024)*10;
export const fileInterceptor = FileInterceptor('file', {
  storage: diskStorage({
    destination: 'uploads',
    filename: changeImgName,
  }),
  fileFilter: typeAccepted,
  limits: { fileSize: sizeFile }
});
 
export const fieldMemberFileInterceptor = FileFieldsInterceptor([
  { name: 'avatar', maxCount: 1 },
  { name: 'background', maxCount: 1 },
],
  {
    storage: diskStorage({
      destination: 'uploads',
      filename: changeImgName,
    }),
    fileFilter: typeAccepted,
    limits: { fileSize: sizeFile }
  });