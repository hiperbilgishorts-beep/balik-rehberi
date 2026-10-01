import { mkdir } from 'node:fs/promises';
import sharp from 'sharp';

await mkdir(new URL('../assets/', import.meta.url), { recursive: true });
const asset = (name) => new URL(`../assets/${name}`, import.meta.url);
await sharp(asset('icon.svg')).resize(1024, 1024).png().toFile(asset('icon.png'));
await sharp(asset('adaptive-icon.svg')).resize(1024, 1024).png().toFile(asset('adaptive-icon.png'));
await sharp(asset('icon.svg')).resize(64, 64).png().toFile(asset('favicon.png'));
await sharp(asset('splash.svg')).resize(1242, 2436, { fit: 'contain', background: '#073b35' }).png().toFile(asset('splash.png'));
console.log('Generated app icon, adaptive icon, favicon and splash assets.');
