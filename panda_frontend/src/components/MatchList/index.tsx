import React from 'react';

import styles from './style.module.css';

interface MatchItem {
  id: number;
  name: string;
  scheduled_at: string;
}

interface MatchProps {
  matches: MatchItem[];
}

function renderDateTime(dateString: string): string {
  const date = new Date(dateString);

  const options: Intl.DateTimeFormatOptions = {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    hour12: true,
  };

  const formattedDateTime = date.toLocaleString(undefined, options);

  return formattedDateTime;
}

export const MatchList: React.FC<MatchProps> = ({ matches }) => (
  <table className={styles.table}>
    <thead>
      <tr className={styles.header}>
        <th className={styles.cell}>ID</th>
        <th className={styles.cell}>Name</th>
        <th className={styles.cell}>Scheduled At</th>
      </tr>
    </thead>
    <tbody>
      {matches.map((item: MatchItem) => (
        <tr key={item.id}>
          <td className={styles.cell}>{item.id}</td>
          <td className={styles.cell}>{item.name}</td>
          <td className={styles.cell}>{renderDateTime(item.scheduled_at)}</td>
        </tr>
      ))}
    </tbody>
  </table>
);
