<template>
    <ion-page>
        <ion-header>
            <ion-toolbar>
                <ion-title>
                    <div class="admin-logo">
                        <img src="../../public/img/cpclogo.jpg" alt="CPC Logo" />
                    </div>
                </ion-title>
            </ion-toolbar>
        </ion-header>
        <ion-content class="ad-background">
        <div class="container">
            <h1 class="adminLogIn-title">LOG IN</h1>
                <form @submit.prevent="logIn">
                    <div class="ad-user-icon">
                        <img src="../../public/img/user-icon.png" alt="user-icon">
                    </div>
                    <ion-item>
                        <ion-label position="stacked">Username:</ion-label>
                        <ion-input v-model="username" type="text" required></ion-input>
                    </ion-item>

                    <ion-item>
                        <ion-label position="stacked">Password:</ion-label>
                        <ion-input v-model="password" type="text" required></ion-input>
                    </ion-item>

                    <ion-button expand="block" type="submit" class="adLogInbtn">Log In</ion-button>
                </form>
        </div>
            <div class="footer">
                <ion-text>
                    <small>&copy; All Rights Reserved PPG 2025.</small>
                </ion-text>
            </div>
    </ion-content>   
    </ion-page>
</template>

<script setup lang="ts">
import { IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from '@ionic/vue';
</script>

<style scoped>
.toolbar-container::part(backdrop) {
  background-color: #07055D !important;
}
ion-content {
  --background: #f6f6f6;
  padding: 20px;
}
ion-input::part(native) {
  padding: 0 !important; 
  margin-top: 10px;
}
ion-button {
  width: 200px;
  color: #fff;
  margin: 10px auto !important;
  font-size: 20px;
}
ion-button::part(native){
     padding: 10px;
    border-radius: 10px;
    margin-top: 20px;
    margin-bottom: 0;
}

.container form {
    display: block;
    width: 450px;
    opacity: 0.85;
    padding: 30px 10px;
    background-color: #FFFFFF;
    border-radius: 10px;
    margin: 0 auto;
    margin-bottom: 25px !important;
    font-family: 'Hind Kochi', sans-serif !important;
}

ion-item {
  --background:none;
  --highlight-color-focused: #07055D;
  border-radius: 8px;
  overflow: hidden;
  margin-bottom: 0px;
  display: block;
  padding: 0 !important;
  --inner-border-width: 0;
}

ion-label {
  font-size: 24px !important;
  color: #000 !important;
  padding-bottom: 10px !important;
  font-family: 'Hind Kochi', sans-serif !important;
  font-weight: 500;
}

ion-input {
    --padding-start: 10px;
    background-color: #d7d8da;
    margin-top: 10px !important;
    color: #1e1e1e;
    border-radius: 3px;
    font-family: 'Hind Kochi', sans-serif !important;
}

.adLogInbtn {
  --background: #07055D;
  --background-activated: #05044a;
  --border-radius: 8px;
  font-weight: bold;
  margin-top: 10px;
  font-family: 'Hind Kochi', sans-serif !important;
}
.ad-user-icon{
  text-align: center;
}
.ad-user-icon img{
  height: 100px;
}
.ad-background{
    --background: url('../../public/img/admin-bg.png');
    background-size: cover;
    background-repeat: no-repeat;
    background-position: center;
    
}
.admin-logo{
    display: flex;
    height: 75px;
    margin-left: 10px;
    padding: 3px;
}
.adminLogIn-title{
    text-align: center;
    font-size: 30px;
    font-weight: 600;
    font-family: 'Hind Kochi', sans-serif !important;
}
</style>