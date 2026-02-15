# Google Play Store Publishing Guide - Step by Step

## ✅ Prerequisites Completed
- [x] App Bundle built: `app-release.aab` (49.2 MB)
- [x] App is signed with your keystore
- [x] Privacy Policy created

---

## 📝 Step 3: Create Google Play Console Account

1. **Go to Google Play Console**
   - Visit: https://play.google.com/console
   - Sign in with your Google account

2. **Pay Registration Fee**
   - One-time fee: $25 USD
   - Payment required before publishing any app

3. **Complete Developer Profile**
   - Developer name
   - Contact information
   - Email address (will be visible to users)

---

## 🚀 Step 4: Create Your App

1. **Click "Create App"**
2. **Fill in Basic Information:**
   - **App name**: الأذكار - Al-Adkar
   - **Default language**: Arabic (العربية)
   - **App or Game**: App
   - **Free or Paid**: Free

3. **Declarations:**
   - Check the boxes confirming:
     - ✓ You own the app
     - ✓ App follows Play policies
     - ✓ App complies with export laws

---

## 📋 Step 5: Fill Out Store Listing

### Main Store Listing

1. **Go to "Store Presence" → "Main Store Listing"**

2. **App Details:**
   - **App name**: الأذكار - Al-Adkar
   - **Short description**: (Copy from PLAY_STORE_INFO.md)
   - **Full description**: (Copy from PLAY_STORE_INFO.md)

3. **App Icon:**
   - Upload 512x512 PNG
   - Must be high quality, no alpha channel

4. **Feature Graphic:**
   - 1024x500 PNG
   - Banner image for Play Store

5. **Screenshots:**
   - Upload at least 2 phone screenshots
   - Recommended: 4-8 screenshots
   - Size: 1080x1920 px or 1080x2400 px

6. **App Category:**
   - Select: **Lifestyle**

7. **Contact Details:**
   - Email: abdouclk@gmail.com (or your email)
   - Website: (optional)
   - Phone: (optional)

---

## 🔒 Step 6: Privacy Policy

1. **In Store Listing, scroll to "Privacy Policy"**
2. **Enter Privacy Policy URL:**
   - Option 1: Host PRIVACY_POLICY.md on GitHub Pages
   - Option 2: Create page on your website
   - Option 3: Use services like https://www.privacypolicies.com/

**How to host on GitHub:**
```bash
# Enable GitHub Pages in repository settings
# URL will be: https://abdouclk.github.io/Al_Adkar/PRIVACY_POLICY.html
```

---

## ⚙️ Step 7: App Content Settings

### Content Rating
1. **Go to "Policy" → "App Content"**
2. **Click "Start Questionnaire"**
3. **Answer questions:**
   - Category: Reference, Education, or Lifestyle
   - Answer truthfully (app has no violence, adult content, etc.)
4. **Submit** - You'll receive an "Everyone" or "3+" rating

### Target Audience
1. **Set Age Groups:**
   - Check: All ages (app is safe for everyone)

### News App Declaration
- Select: **Not a news app**

### COVID-19 Contact Tracing & Status
- Select: **No**

### Data Safety
1. **Fill out Data Safety Form:**
   - Does app collect or share data? **NO**
   - Location data: Used only locally, not collected
   - No personal data collected
   - No data shared with third parties

### Ads Declaration
- Does app contain ads? **NO**

---

## 🎯 Step 8: Select Countries

1. **Go to "Production" → "Countries/Regions"**
2. **Select countries:**
   - Recommended: All supported countries
   - Or focus on: Morocco, Saudi Arabia, Egypt, UAE, etc.

---

## 📦 Step 9: Upload App Bundle

1. **Go to "Release" → "Production"**
2. **Click "Create New Release"**

3. **Upload App Bundle:**
   - Click "Upload"
   - Select: `build\app\outputs\bundle\release\app-release.aab`
   - Wait for upload and processing

4. **Release Name:**
   - Version: 1.0.0

5. **Release Notes (in Arabic):**
   ```
   النسخة الأولى من تطبيق الأذكار:
   • أذكار الصباح والمساء
   • تذكير ذكي كل ساعتين
   • أوقات الصلاة الدقيقة
   • اتجاه القبلة
   • إذاعة القرآن الكريم
   • نظام المفضلة
   • دعم الوضع الليلي
   ```

---

## ✅ Step 10: Review and Publish

1. **Complete All Required Sections:**
   - Store listing ✓
   - App content ✓
   - Privacy policy ✓
   - Countries ✓
   - App bundle uploaded ✓

2. **Review for Issues:**
   - Dashboard will show any incomplete sections
   - Fix all warnings and errors

3. **Click "Send for Review"**

4. **Wait for Review:**
   - Usually takes 1-7 days
   - You'll receive email when approved
   - Check for any rejection reasons

---

## 🎉 Step 11: After Approval

### Your App is Live!
- URL: `https://play.google.com/store/apps/details?id=com.abdouclk.aladkar`
- Share with users
- Monitor reviews and ratings

### Update Process (Future Updates):
1. Increase version code in `pubspec.yaml`
2. Build new app bundle
3. Upload to Production → Create new release
4. Much faster approval (hours, not days)

---

## 📊 Checklist Before Submission

- [ ] App Bundle built and tested
- [ ] Privacy Policy URL ready
- [ ] App icon (512x512 PNG)
- [ ] Feature graphic (1024x500 PNG)
- [ ] At least 2 screenshots
- [ ] Short description written
- [ ] Full description written
- [ ] Content rating questionnaire completed
- [ ] Data safety form filled
- [ ] All app policies accepted
- [ ] $25 registration fee paid

---

## 🛠️ Common Issues & Solutions

### Issue: "Your app is not signed correctly"
**Solution:** App is already signed with keystore in `android/key.properties`

### Issue: "Missing privacy policy"
**Solution:** Host PRIVACY_POLICY.md online and add URL

### Issue: "Icon doesn't meet requirements"
**Solution:** 
- Must be 512x512 PNG
- 32-bit format
- No transparency

### Issue: "Screenshots required"
**Solution:** Take at least 2 screenshots using Android emulator or physical device

---

## 📞 Support

**Google Play Console Help:**
https://support.google.com/googleplay/android-developer

**App Package Name:** com.abdouclk.aladkar

**Need help?** Contact Google Play Console support from the dashboard.

---

## 🎯 Next Steps

1. Create Play Console account ($25)
2. Host privacy policy online
3. Take screenshots of your app
4. Create app icon (512x512)
5. Create feature graphic (1024x500)
6. Follow this guide step by step
7. Submit for review!

Good luck! Your app is ready for the world! 🚀
