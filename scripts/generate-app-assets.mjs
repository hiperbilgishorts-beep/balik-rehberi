import { mkdir } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import sharp from 'sharp';

const root = dirname(fileURLToPath(import.meta.url));
const assets = join(root, '..', 'assets');
await mkdir(assets, { recursive: true });
const asset = (name) => join(assets, name);

await sharp(asset('icon.svg')).resize(1024, 1024).png().toFile(asset('icon.png'));
await sharp(asset('adaptive-icon.svg')).resize(1024, 1024).png().toFile(asset('adaptive-icon.png'));
await sharp(asset('icon.svg')).resize(64, 64).png().toFile(asset('favicon.png'));
await sharp(asset('splash.svg')).resize(1242, 2436, { fit: 'contain', background: '#073b35' }).png().toFile(asset('splash.png'));
console.log('Generated app icon, adaptive icon, favicon and splash assets.');
