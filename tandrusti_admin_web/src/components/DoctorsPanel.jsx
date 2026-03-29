import { useState, useEffect } from 'react';
import { db } from '../firebase';
import { collection, getDocs, addDoc, updateDoc, deleteDoc, doc } from 'firebase/firestore';
import { Edit2, Trash2, X, Save, Plus } from 'lucide-react';

export default function DoctorsPanel() {
  const [doctors, setDoctors] = useState([]);
  const [loading, setLoading] = useState(true);
  const [editingId, setEditingId] = useState(null);
  const [isAdding, setIsAdding] = useState(false);
  
  // Form State
  const [formData, setFormData] = useState({
    name: '', specialty: '', city: '', phoneNumber: '', clinicLocation: '', 
    workingHours: '', rating: 5.0, latitude: 0, longitude: 0
  });

  const fetchDoctors = async () => {
    setLoading(true);
    try {
      const snap = await getDocs(collection(db, 'doctors'));
      const docsData = snap.docs.map(d => ({ id: d.id, ...d.data() }));
      setDoctors(docsData);
    } catch (error) {
      console.error("Error fetching doctors", error);
    }
    setLoading(false);
  };

  useEffect(() => {
    fetchDoctors();
  }, []);

  const handleEditClick = (docInfo) => {
    setEditingId(docInfo.id);
    setIsAdding(false);
    setFormData({
      name: docInfo.name || '',
      specialty: docInfo.specialty || '',
      city: docInfo.city || '',
      phoneNumber: docInfo.phoneNumber || '',
      clinicLocation: docInfo.clinicLocation || '',
      workingHours: docInfo.workingHours || '',
      rating: docInfo.rating || 5.0,
      latitude: docInfo.latitude || 0,
      longitude: docInfo.longitude || 0,
    });
  };

  const handleDelete = async (id) => {
    if (window.confirm("Are you sure you want to delete this doctor?")) {
      await deleteDoc(doc(db, 'doctors', id));
      fetchDoctors();
    }
  };

  const handleSave = async (e) => {
    e.preventDefault();
    try {
      const payload = {
        ...formData,
        rating: parseFloat(formData.rating),
        latitude: parseFloat(formData.latitude),
        longitude: parseFloat(formData.longitude),
      };

      if (isAdding) {
        await addDoc(collection(db, 'doctors'), payload);
      } else if (editingId) {
        await updateDoc(doc(db, 'doctors', editingId), payload);
      }
      
      setEditingId(null);
      setIsAdding(false);
      fetchDoctors();
    } catch (err) {
      alert("Error saving: " + err.message);
    }
  };

  const resetForm = () => {
    setFormData({
      name: '', specialty: '', city: '', phoneNumber: '', clinicLocation: '', 
      workingHours: '', rating: 5.0, latitude: 0, longitude: 0
    });
    setEditingId(null);
    setIsAdding(false);
  };

  return (
    <div className="bg-surface rounded-xl p-8 border border-borderLight shadow-sm">
      <div className="flex justify-between items-center mb-6">
        <h3 className="text-xl font-bold">Doctors Directory</h3>
        {!isAdding && !editingId && (
          <button 
            onClick={() => { setIsAdding(true); setFormData({name: '', specialty: '', city: '', phoneNumber: '', clinicLocation: '', workingHours: '', rating: 5.0, latitude: 0, longitude: 0}); }}
            className="flex items-center bg-primary hover:bg-primaryDark text-white px-4 py-2 rounded-lg font-medium transition-colors"
          >
            <Plus className="w-5 h-5 mr-2" /> Add New Doctor
          </button>
        )}
      </div>

      {loading && <p className="text-textMuted italic">Loading doctors from Firestore...</p>}

      {/* Editor / Add Form */}
      {(isAdding || editingId) && (
        <form onSubmit={handleSave} className="bg-background p-6 rounded-lg border border-borderLight mb-8">
          <div className="flex justify-between items-center mb-4">
            <h4 className="text-lg font-bold">{isAdding ? 'Add New Doctor' : '✏️ Edit Doctor'}</h4>
            <button type="button" onClick={resetForm} className="text-textMuted hover:text-red-500">
              <X className="w-5 h-5" />
            </button>
          </div>
          
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-semibold mb-1">Name</label>
              <input required value={formData.name} onChange={e => setFormData({...formData, name: e.target.value})} className="w-full border p-2 rounded focus:ring-2 outline-none" placeholder="e.g. Dr. Alan Kurdi" />
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">Specialty</label>
              <input required value={formData.specialty} onChange={e => setFormData({...formData, specialty: e.target.value})} className="w-full border p-2 rounded focus:ring-2 outline-none" placeholder="e.g. Cardiologist" />
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">City</label>
              <input required value={formData.city} onChange={e => setFormData({...formData, city: e.target.value})} className="w-full border p-2 rounded focus:ring-2 outline-none" placeholder="e.g. Erbil" />
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">Phone Number</label>
              <input required value={formData.phoneNumber} onChange={e => setFormData({...formData, phoneNumber: e.target.value})} className="w-full border p-2 rounded focus:ring-2 outline-none" placeholder="+964..." />
            </div>
            <div className="col-span-2">
              <label className="block text-sm font-semibold mb-1">Clinic Location</label>
              <input required value={formData.clinicLocation} onChange={e => setFormData({...formData, clinicLocation: e.target.value})} className="w-full border p-2 rounded focus:ring-2 outline-none" placeholder="100 Meter Road..." />
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">Working Hours</label>
              <input required value={formData.workingHours} onChange={e => setFormData({...formData, workingHours: e.target.value})} className="w-full border p-2 rounded focus:ring-2 outline-none" placeholder="e.g. 4:00 PM - 8:00 PM" />
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">Rating</label>
              <input required type="number" step="0.1" value={formData.rating} onChange={e => setFormData({...formData, rating: e.target.value})} className="w-full border p-2 rounded focus:ring-2 outline-none" />
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">Latitude</label>
              <input required type="number" step="0.000001" value={formData.latitude} onChange={e => setFormData({...formData, latitude: e.target.value})} className="w-full border p-2 rounded focus:ring-2 outline-none" />
            </div>
            <div>
              <label className="block text-sm font-semibold mb-1">Longitude</label>
              <input required type="number" step="0.000001" value={formData.longitude} onChange={e => setFormData({...formData, longitude: e.target.value})} className="w-full border p-2 rounded focus:ring-2 outline-none" />
            </div>
          </div>
          <button type="submit" className="mt-6 flex items-center bg-primary text-white px-6 py-2 rounded-lg font-bold hover:bg-primaryDark transition-colors">
            <Save className="w-5 h-5 mr-2" /> Save Doctor
          </button>
        </form>
      )}

      {/* Directory Table */}
      {!loading && doctors.length > 0 && (
        <div className="overflow-x-auto">
          <table className="w-full text-left border-collapse">
            <thead>
              <tr className="bg-background border-b border-borderLight text-textMuted uppercase text-xs">
                <th className="p-4 font-semibold">Name</th>
                <th className="p-4 font-semibold">Specialty</th>
                <th className="p-4 font-semibold">City</th>
                <th className="p-4 font-semibold">Phone</th>
                <th className="p-4 font-semibold text-center">Actions</th>
              </tr>
            </thead>
            <tbody>
              {doctors.map(doc => (
                <tr key={doc.id} className="border-b border-borderLight hover:bg-background transition-colors">
                  <td className="p-4 font-medium">{doc.name}</td>
                  <td className="p-4 text-sm text-textMuted">{doc.specialty}</td>
                  <td className="p-4 text-sm">{doc.city}</td>
                  <td className="p-4 text-sm">{doc.phoneNumber}</td>
                  <td className="p-4 flex items-center justify-center gap-3">
                    <button onClick={() => handleEditClick(doc)} className="text-blue-500 hover:text-blue-700 bg-blue-50 p-2 rounded-lg transition-colors" title="Edit">
                      <Edit2 className="w-4 h-4" />
                    </button>
                    <button onClick={() => handleDelete(doc.id)} className="text-red-500 hover:text-red-700 bg-red-50 p-2 rounded-lg transition-colors" title="Delete">
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
