import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { MatchList } from '../MatchList'

interface MatchItem {
  id: number;
  name: string;
  scheduled_at: string;
}

export function MatchData() {
  const [data, setData] = useState<MatchItem[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null); // Add this line

  useEffect(() => {
    let isMounted = true;

    axios.get<MatchItem[]>('http://localhost:4000/upcoming_matches')
      .then(response => {
        if (isMounted) {
          setData(response.data);
          setLoading(false);
        }
      })
      .catch(error => {
        console.error('Error fetching data:', error);
        if (isMounted) {
          setLoading(false);
          setError(error.message); // Add this line
        }
      });

    return () => {
      isMounted = false;
    };
  }, []);

  return (
    <div>
      <h1>Latest Matches</h1>
      {loading ? (
        <p>Loading...</p>
      ) : error ? ( // Add this block
        <p>Error: {error}</p>
      ) : (
        <MatchList matches={data} />
      )}
    </div>
  );
}
