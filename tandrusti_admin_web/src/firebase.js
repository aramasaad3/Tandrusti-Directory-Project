import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";

const firebaseConfig = {
  apiKey: "AIzaSyB8ZC_OT0fTxjpn9w-k_5vX1ifTXp3C-V4",
  authDomain: "ttandrusti-3bacf.firebaseapp.com",
  projectId: "ttandrusti-3bacf",
  storageBucket: "ttandrusti-3bacf.firebasestorage.app",
  messagingSenderId: "878321739997",
  appId: "1:878321739997:web:6312a942b622eaf835d334",
  measurementId: "G-VH25J3V4HT"
};

export const app = initializeApp(firebaseConfig);
export const auth = getAuth(app);
export const db = getFirestore(app);
