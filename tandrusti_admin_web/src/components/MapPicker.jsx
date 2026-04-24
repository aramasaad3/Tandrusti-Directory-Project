import { useEffect, useRef } from 'react';
import L from 'leaflet';
import 'leaflet/dist/leaflet.css';

// Fix default marker icon issue with Webpack/Vite
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png',
  iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
  shadowUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png',
});

export default function MapPicker({ lat, lng, onLocationSelect }) {
  const mapRef = useRef(null);
  const markerRef = useRef(null);
  const mapContainerRef = useRef(null);

  const initLat = lat && lat !== 0 ? lat : 36.191;
  const initLng = lng && lng !== 0 ? lng : 43.993;

  useEffect(() => {
    if (mapRef.current) return; // already initialized

    mapRef.current = L.map(mapContainerRef.current).setView([initLat, initLng], 13);

    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '© OpenStreetMap contributors',
    }).addTo(mapRef.current);

    // Place initial marker if coordinates exist
    if (lat && lat !== 0) {
      markerRef.current = L.marker([lat, lng]).addTo(mapRef.current);
    }

    mapRef.current.on('click', (e) => {
      const { lat: clickLat, lng: clickLng } = e.latlng;

      if (markerRef.current) {
        markerRef.current.setLatLng([clickLat, clickLng]);
      } else {
        markerRef.current = L.marker([clickLat, clickLng]).addTo(mapRef.current);
      }

      onLocationSelect(clickLat, clickLng);
    });

    return () => {
      if (mapRef.current) {
        mapRef.current.remove();
        mapRef.current = null;
      }
    };
  }, []);

  // Update marker when lat/lng props change externally
  useEffect(() => {
    if (mapRef.current && lat && lat !== 0) {
      if (markerRef.current) {
        markerRef.current.setLatLng([lat, lng]);
      } else {
        markerRef.current = L.marker([lat, lng]).addTo(mapRef.current);
      }
      mapRef.current.setView([lat, lng], 14);
    }
  }, [lat, lng]);

  return (
    <div className="mt-2 rounded-lg overflow-hidden border border-borderLight" style={{ height: '300px' }}>
      <div ref={mapContainerRef} style={{ height: '100%', width: '100%' }} />
    </div>
  );
}
