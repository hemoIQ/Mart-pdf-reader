# Smart PDF Reader - قارئ الكتب الذكي

تطبيق سطح مكتب لقراءة ملفات PDF مع دعم التحديثات التلقائية من GitHub.

## المميزات

✅ **يعمل بدون إنترنت** - التطبيق يعمل محلياً بدون الحاجة للإنترنت
✅ **تحديثات تلقائية** - يتحقق تلقائياً من التحديثات عند الاتصال
✅ **حفظ الكتب محلياً** - يتم حفظ الكتب في مجلد خاص في البرنامج
✅ **لا يظهر نافذة CMD** - واجهة نظيفة بدون نوافذ سوداء

## المتطلبات السابقة
- Node.js و npm مثبتان على النظام
- (اختياري) Git للتحكم في الإصدارات

## التثبيت والتشغيل

### 1. تثبيت الحزم
```powershell
npm install
```

### 2. تشغيل أثناء التطوير
```powershell
npm run start
```

### 3. بناء نسخة قابلة للتوزيع
```powershell
npm run dist
```

النواتج ستوضع داخل مجلد `dist\`.

## مجلد الكتب

يتم حفظ الكتب تلقائياً في:
```
%APPDATA%\smart-pdf-reader\books\
```

## التحديثات التلقائية

التطبيق يدعم التحديثات التلقائية من GitHub Releases:
- عند بدء التشغيل (إذا متصل بالإنترنت)، يتحقق التطبيق من وجود تحديثات جديدة
- إذا توفر تحديث، سيُعرض مربع حوار للمستخدم
- يمكن تحميل وتثبيت التحديث بنقرة واحدة
- **إذا مقطوع الإنترنت** - التطبيق يعمل عادي بدون مشاكل!

## رفع المشروع على GitHub

### 1. تهيئة Git
```powershell
git init
git add .
git commit -m "Initial commit"
```

### 2. إنشاء Repository على GitHub
1. اذهب إلى https://github.com/new
2. أنشئ repository جديد باسم `smart-pdf-reader`
3. لا تضف README أو .gitignore (موجودان بالفعل)

### 3. ربط المشروع المحلي بـ GitHub
```powershell
git remote add origin https://github.com/YOUR_USERNAME/smart-pdf-reader.git
git branch -M main
git push -u origin main
```

**مهم:** استبدل `YOUR_USERNAME` باسم المستخدم الخاص بك في:
- `package.json` (حقول `repository` و `publish`)

## إنشاء إصدار جديد (Release)

### الطريقة الأولى: يدوياً عبر GitHub
1. ابنِ المشروع محلياً: `npm run dist`
2. اذهب إلى GitHub repository
3. انقر **Releases** → **Create a new release**
4. أنشئ tag جديد (مثل `v0.1.0`)
5. عنوان الإصدار: `الإصدار الأول v0.1.0`
6. ارفع ملفات `.exe` من مجلد `dist\`
7. انقر **Publish release**

### الطريقة الثانية: تلقائياً عبر GitHub Actions
1. قم بتحديث رقم الإصدار في `package.json`
2. أنشئ tag وارفعه:
```powershell
git tag v0.1.0
git push origin v0.1.0
```
3. GitHub Actions سيبني وينشر الإصدار تلقائياً!

**ملاحظة:** للنشر التلقائي، تأكد من أن GitHub Actions لديه صلاحيات الكتابة:
- Settings → Actions → General → Workflow permissions → Read and write permissions

## إيقاف التطبيق
```powershell
Get-Process electron | Stop-Process
```

## ملاحظات
- التحديثات التلقائية تعمل فقط في النسخ المبنية (built versions)، وليس في وضع التطوير
- التطبيق **يعمل بدون إنترنت** - التحديثات فقط تحتاج نت
- لتوقيع الكود (code signing) على Windows، ستحتاج إلى شهادة رقمية
- يمكن تعطيل فحص التحديثات بتعيين متغير البيئة `DEBUG=true`
