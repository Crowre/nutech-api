import { fileURLToPath } from 'url';
import path from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const rootDir = __dirname;
export const controllersDir = path.join(__dirname, '../controllers');
export const middlewareDir = path.join(__dirname, '../middleware');