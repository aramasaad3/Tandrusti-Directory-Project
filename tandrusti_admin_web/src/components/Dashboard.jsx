import { useState, useEffect } from 'react';
import { db } from '../firebase';
import { collection, getCountFromServer } from 'firebase/firestore';

export default function Dashboard() {
  const [stats, setStats] = useState({ doctors: 0, medicines: 0, tests: 0 });
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchStats() {
      try {
        const [docSnap, medSnap, testSnap] = await Promise.all([
          getCountFromServer(collection(db, 'doctors')),
          getCountFromServer(collection(db, 'medicines')),
          getCountFromServer(collection(db, 'tests'))
        ]);
        
        setStats({
          doctors: docSnap.data().count,
          medicines: medSnap.data().count,
          tests: testSnap.data().count
        });
      } catch (err) {
        console.error("Failed to load dashboard stats", err);
      }
      setLoading(false);
    }
    fetchStats();
  }, []);

  return (
    <div className="bg-surface rounded-xl p-8 border border-borderLight shadow-sm">
      <h3 className="text-xl font-bold mb-4">Welcome to the Admin Dashboard</h3>
      <p className="text-textMuted">From here, you can manage the Tandrusti database in real-time. Any changes made here are instantly pushed to all mobile apps.</p>
      
      <div className="grid grid-cols-3 gap-6 mt-8">
        <div className="bg-blue-50 p-6 rounded-lg border border-blue-100 shadow-inner">
          <p className="font-semibold text-blue-900 uppercase text-xs tracking-wider">Total Doctors</p>
          <p className="text-4xl font-bold text-blue-600 mt-2">
            {loading ? '...' : stats.doctors}
          </p>
        </div>
        <div className="bg-green-50 p-6 rounded-lg border border-green-100 shadow-inner">
          <p className="font-semibold text-green-900 uppercase text-xs tracking-wider">Medicines</p>
          <p className="text-4xl font-bold text-green-600 mt-2">
            {loading ? '...' : stats.medicines}
          </p>
        </div>
        <div className="bg-amber-50 p-6 rounded-lg border border-amber-100 shadow-inner">
          <p className="font-semibold text-amber-900 uppercase text-xs tracking-wider">Lab Tests</p>
          <p className="text-4xl font-bold text-amber-600 mt-2">
            {loading ? '...' : stats.tests}
          </p>
        </div>
      </div>
      
      <div className="mt-8 bg-gray-50 border border-gray-200 rounded-lg p-6">
         <h4 className="font-bold text-gray-800 mb-2">💡 Quick Tip</h4>
         <p className="text-gray-600 text-sm">When filling out Kurdish (Sorani) fields in the Medicines and Tests sections, the inputs automatically support right-to-left layout for ease of reading.</p>
      </div>
    </div>
  );
}
