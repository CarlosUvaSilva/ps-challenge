import React, { useState, useEffect } from 'react';
import axios from 'axios';

import styles from './style.module.css';
import { MatchList } from '../MatchList';

interface MatchItem {
  id: number;
  name: string;
  scheduled_at: string;
}

export function MatchData() {
  const [data, setData] = useState<MatchItem[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState<string>('');
  const [debouncedSearchTerm, setDebouncedSearchTerm] = useState<string>(searchTerm);

  useEffect(() => {
    const timerId = setTimeout(() => {
      setDebouncedSearchTerm(searchTerm);
    }, 500); // 500ms delay

    return () => clearTimeout(timerId);
  }, [searchTerm]);

  useEffect(() => {
    let isMounted = true;
    setLoading(true);

    const url = debouncedSearchTerm
      ? `http://localhost:4000/upcoming_matches?team=${encodeURIComponent(debouncedSearchTerm)}`
      : 'http://localhost:4000/upcoming_matches';

    axios.get<MatchItem[]>(url)
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
          setError(error.message);
        }
      });

    return () => {
      isMounted = false;
    };
  }, [debouncedSearchTerm]);

  return (
    <div>
      <h1>Latest Matches</h1>
      <input
        className={styles.inputField}
        type="text"
        value={searchTerm}
        onChange={(e) => setSearchTerm(e.target.value)}
        placeholder="Search by team..."
      />
      {loading ? (
        <p>Loading...</p>
      ) : error ? (
        <p>Error: {error}</p>
      ) : (
        <MatchList matches={data} />
      )}
    </div>
  );
}
